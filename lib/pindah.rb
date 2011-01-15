require "rake"
require "fileutils"
require "pp"

begin
  require "mirah"
  require 'ant'
rescue LoadError
  abort 'This Rakefile requires JRuby. Please use jruby -S rake.'
end

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

  task :dirs do
    ["gen", @spec[:output], @spec[:classes]].each do |d|
      FileUtils.mkdir_p(d)
    end
  end

  desc "Prepare resources"
  task :resources => :dirs do
    # TODO: load tasks from android_rules in tools/ant/ant_rules_r1.xml
    # ant["-resource-src"].execute
    # TODO: jruby can't find the java compiler; wtf
    # ant.javac(:srcdir => "gen",
    #           :destdir => @spec[:classes])
  end

  desc "Compile Mirah source to JVM bytecode"
  task :compile => [:dirs, :resources] do
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

  desc "Translate JVM bytecode to Dalvik bytecode"
  task :dex => :compile

  task :package_resources => :resources

  desc "Create an .apk file for the application"
  task :package => [:manifest, :dex, :package_resources]

  desc "Install the application on a device or emulator"
  task :install => :package

  task :release => :package

  desc "Tail logs from a device or a device or emulator"
  task :logcat do
    system "adb -d logcat #{@spec[:log_filter]}"
  end

  desc "Print the project spec"
  task :spec do
    pp @spec
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

    require "#{@spec[:sdk]}/tools/lib/anttasks.jar"
  end

  def self.infer_sdk_location
    # TODO: implement
  end
end
