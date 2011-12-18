require "rake"
require "fileutils"
require "tempfile"
require "pp"
require "erb"

begin
  require 'ant'
rescue LoadError
  abort 'This Rakefile requires JRuby. Please use jruby -S rake.'
end

require "mirah"

module Pindah
  class << self
    include Rake::DSL
  end

  VERSION = '0.1.2'

  def self.infer_sdk_location(path)
    tools = path.split(File::PATH_SEPARATOR).detect {|p| File.exists?("#{p}/android") || File.exists?("#{p}/android.bat") }
    abort "\"android\" executable not found on $PATH" if tools.nil?
    File.expand_path("#{tools}/..")
  end

  DEFAULTS = { :output => File.expand_path("bin"),
    :src => File.expand_path("src"),
    :classpath => Dir["jars/*jar", "libs/*jar"],
    :sdk => Pindah.infer_sdk_location(ENV["PATH"])
  }

  TARGETS = { "1.5" => 3, "1.6" => 4,
    "2.1" => 7, "2.2" => 8, "2.3" => 9, "2.3.3" => 9, "2.3.4" => 10,
    "3.0" => 11, "3.1" => 12, "3.2" => 13 }

  ANT_TASKS = ["clean", "javac", "compile", "debug", "release",
               "install", "uninstall"]

  task :generate_manifest # TODO: generate from yaml?

  desc "Tail logs from a device or a device or emulator"
  task :logcat do
    system "adb logcat #{@spec[:log_spec]}"
  end

  desc "Print the project spec"
  task :spec do
    pp @spec
  end

  task :default => [:install]

  def self.spec=(spec)
    abort "Must provide :target_version in Pindah.spec!" if !spec[:target_version]
    abort "Must provide :name in Pindah.spec!" if !spec[:name]

    @spec = DEFAULTS.merge(spec)

    @spec[:root] = File.expand_path "."
    @spec[:target] ||= TARGETS[@spec[:target_version].to_s.sub(/android-/, '')]
    @spec[:classes] ||= "#{@spec[:output]}/classes/"
    @spec[:classpath] << @spec[:classes]
    
    if @spec.has_key?(:libraries)
      @spec[:libraries].each do |path|
        # TODO: do libraries always build to bin/classes?
        @spec[:classpath] << "#{File.expand_path path}/bin/classes/"
      end
    end
    
    @spec[:classpath] << "#{@spec[:sdk]}/platforms/android-#{@spec[:target]}/android.jar"
    @spec[:log_spec] ||= "ActivityManager:I #{@spec[:name]}:D " +
      "AndroidRuntime:E *:S"

    ant_setup
  end

  def self.ant_setup
    @ant = Ant.new

    # TODO: this is lame, but ant interpolation doesn't work for project name
    build_template = ERB.new(File.read(File.join(File.dirname(__FILE__), '..',
                                                 'templates', 'build.xml')))
    build = Tempfile.new(["pindah-build", ".xml"])
    build.write(build_template.result(binding))
    build.close

    mirah_src_dir = File.join(@spec[:src], "mirah")
    java_src_dir = File.join(@spec[:src], "java")
    # check to see if there is a mirah subdirectory in the sources
    if File.directory?(mirah_src_dir)
      # if so, make sure a java source directory exists.  Otherwise, Ant will
      # fail
      unless File.exists?(java_src_dir)
	puts "=== Creating empty Java source directory ==="
	Dir.mkdir(java_src_dir)
      end
    else
      # if not, print a warning and set both directories to be the one from the
      # spec
      puts "==== WARNING! =============================================="
      puts "== You are now encouraged to place your source files in   =="
      puts "== a mirah subdirectory, e.g. 'src/mirah' instead of      =="
      puts "== 'src'.  Running in compatibility mode.                 =="
      puts "============================================================"
      java_src_dir = @spec[:src]
      mirah_src_dir = @spec[:src]
    end

    # TODO: add key signing config
    user_properties = {
      "target" => "android-#{@spec[:target]}",
      "target-version" => "android-#{@spec[:target_version]}",
      "source.dir" => java_src_dir, # Override default Java source directory
      "src" => mirah_src_dir,
      "sdk.dir" => @spec[:sdk],
      "classes" => @spec[:classes],
      "classpath" => @spec[:classpath].join(Java::JavaLang::System::
                                            getProperty("path.separator"))
    }
      
    if @spec.has_key?(:libraries)
      @spec[:libraries].each_with_index do |path, i|
        prop = "android.library.reference.#{i + 1}"
        # NB: absolute paths do not work
        user_properties[prop] = path
      end
    end
    
    user_properties.each do |key, value|
      @ant.project.set_user_property(key, value)
    end

    Ant::ProjectHelper.configure_project(@ant.project, java.io.File.new(build.path))

    # Turn ant tasks into rake tasks
    ANT_TASKS.each do |name, description|
      desc @ant.project.targets[name].description
      task(name) { @ant.project.execute_target(name) }
    end
  end
end
