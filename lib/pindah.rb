require "rake"
require "fileutils"
require "pp"
require "erb"

begin
  require 'ant'
rescue LoadError
  abort 'This Rakefile requires JRuby. Please use jruby -S rake.'
end

require "mirah"

module Pindah
  VERSION = '0.1.0.alpha'

  def self.infer_sdk_location(path)
    tools = path.split(":").detect {|p| File.exists? "#{p}/android" }
    File.expand_path("#{tools}/..")
  end

  DEFAULTS = { :output => File.expand_path("bin"),
    :src => File.expand_path("src"),
    :classpath => Dir["jars/*jar"],
    :sdk => Pindah.infer_sdk_location(ENV["PATH"])
  }

  ANT_TASKS = ["clean", "javac", "compile", "debug", "release",
               "install", "uninstall"]

  task :generate_manifest # TODO: generate from yaml?

  desc "Tail logs from a device or a device or emulator"
  task :logcat do
    system "adb -d logcat #{@spec[:log_filter]}"
  end

  desc "Print the project spec"
  task :spec do
    pp @spec
  end

  task :default => [:install]

  def self.spec=(spec)
    abort "Must provide :target version in Pindah.spec!" if !spec[:target]
    abort "Must provide :name in Pindah.spec!" if !spec[:name]

    @spec = DEFAULTS.merge(spec)

    @spec[:root] = File.expand_path "."
    @spec[:classes] ||= "#{@spec[:output]}/classes"
    @spec[:classpath] << @spec[:classes]
    @spec[:classpath] << "#{@spec[:sdk]}/platforms/#{@spec[:target]}/android.jar"
    @spec[:log_spec] ||= "ActivityManager:I #{@spec[:name]}:D " +
      "AndroidRuntime:E *:S"

    ant_setup
  end

  def self.ant_setup
    @ant = Ant.new

    # TODO: this is lame, but ant interpolation doesn't work for project name
    build_template = ERB.new(File.read(File.join(File.dirname(__FILE__), '..',
                                                 'templates', 'build.xml')))
    build = "/tmp/pindah-#{Process.pid}-build.xml"
    File.open(build, "w") { |f| f.puts build_template.result(binding) }
    at_exit { File.delete build }

    { "target" => @spec[:target],
      "target-version" => @spec[:target],
      "sdk.dir" => @spec[:sdk],
      "classes" => @spec[:classes],
      "classpath" => @spec[:classpath].join(Java::JavaLang::System::
                                            getProperty("path.separator"))
    }.each do |key, value|
      @ant.project.set_user_property(key, value)
    end

    # TODO: compile task execs mirahc instead of running inside current JVM
    Ant::ProjectHelper.configure_project(@ant.project, java.io.File.new(build))

    # Turn ant tasks into rake tasks
    ANT_TASKS.each do |name, description|
      desc @ant.project.targets[name].description
      task(name) { @ant.project.execute_target(name) }
    end
  end
end
