require "rake"
require "fileutils"
require "pp"

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

  DEFAULTS = { :output => "bin",
    :src => "src",
    :classpath => [],
    :sdk => Pindah.infer_sdk_location(ENV["PATH"])
  }

  desc "Compile Java source, including resources."
  task :javac do
    # http://www.engineyard.com/blog/2010/rake-and-ant-together-a-pick-it-n-stick-it-approach/
    # TODO: set dirs from @spec
    # TODO: javac in build.xml doesn't pick up gen/**/R.java
    @ant.execute_target("compile")
  end

  # TODO: mirahc from build.xml spawns a separate JVM
  desc "Compile Mirah source to JVM bytecode"
  task :compile => :javac do
    begin
      FileUtils.cd @spec[:src]
      Mirah.compile("-c", @spec[:classpath].join(":"),
                    "-d", "#{@spec[:root]}/#{@spec[:classes]}", ".")
    ensure
      FileUtils.cd @spec[:root]
    end
  end

  desc "Removes output files created by other targets"
  task :clean

  task :manifest # TODO: generate from yaml?

  # desc "Translate JVM bytecode to Dalvik bytecode"
  # task :dex => :compile do
  #   ant["-dex"].execute
  # end

  # task :package_resources => :resources

  # desc "Create an .apk file for the application"
  # task :package => [:manifest, :dex, :package_resources]

  # desc "Install the application on a device or emulator"
  # task :install => :package

  # task :release => :package

  desc "Tail logs from a device or a device or emulator"
  task :logcat do
    system "adb -d logcat #{@spec[:log_filter]}"
  end

  desc "Print the project spec"
  task :spec do
    pp @spec
  end

  task :default do
    @ant.execute_target("debug")
  end

  def self.spec=(spec)
    abort "Must provide :target version in Pindah.spec!" if !spec[:target]
    abort "Must provide :name in Pindah.spec!" if !spec[:name]

    @spec = DEFAULTS.merge(spec)

    @spec[:root] = File.expand_path "."
    @spec[:classes] ||= "#{@spec[:output]}/classes"
    @spec[:classpath] << "#{@spec[:sdk]}/platforms/#{@spec[:target]}/android.jar"
    @spec[:classpath] << "#{@spec[:root]}/#{@spec[:classes]}"
    @spec[:log_spec] ||= "ActivityManager:I #{@spec[:name]}:D AndroidRuntime:E *:S"

    ["anttasks", "androidprefs", "sdklib"].each do |j|
      $CLASSPATH << "#{@spec[:sdk]}/tools/lib/#{j}.jar"
    end

    @ant = Ant.new

    build = "/tmp/pindah-#{Process.pid}-build.xml"
    FileUtils.cp(File.join(File.dirname(__FILE__), 
                           '..', 'templates', 
                           'build.xml'), build)
    at_exit { File.delete build }

    { "target" => @spec[:target],
      "target-version" => @spec[:target],
      "sdk.dir" => @spec[:sdk] }.each do |key, value|
      @ant.project.set_user_property(key, value)
    end

    # ant_import build
    Ant::ProjectHelper.configure_project(@ant.project, java.io.File.new(build))
  end
end
