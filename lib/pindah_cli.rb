require 'fileutils'
require 'erb'

module PindahCLI
  DEFAULT_TARGET = 'android-7'
  DEFAULT_VERSION = 'android-2.1'

  def self.log(msg)
    STDERR.puts msg
  end
  
  def self.create(namespace, location, activity_name=nil)
    segments = namespace.split('.')
    src_dir  = File.join(location, 'src', *segments)
    name = location.split("/").last

    FileUtils.mkdir_p src_dir

    rakefile_location = File.join(location, 'Rakefile')
    rakefile_template = File.read(File.join(File.dirname(__FILE__), 
                                            '..', 'templates', 'Rakefile'))

    File.open(rakefile_location, 'w') do |f|
      f.puts ERB.new(rakefile_template).result(binding)
    end

    log "Created project in #{location}."

    if activity_name
      activity_location = File.join(src_dir, "#{activity_name}.mirah")
      activity_template = File.read(File.join(File.dirname(__FILE__),
                                              '..', 'templates',
                                              'initial_activity.mirah'))

      File.open(activity_location, 'w') do |f|
        f.puts activity_template.gsub(/INITIAL_ACTIVITY/, activity_name)
      end
      log "Created Activity '#{activity_name}' in '#{activity_location}'."
    end
  end
end
