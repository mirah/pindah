require 'fileutils'

module PindahCLI
  DEFAULT_TARGET = 'android-7'
  DEFAULT_VERSION = 'android-2.1'

  def self.log(msg)
    STDERR.puts msg
  end
  
  def self.create(namespace, location, activity_name=nil)
    segments = namespace.split('.')
    src_dir  = File.join(location, 'src', *segments)
    FileUtils.mkdir_p src_dir
    log "Created '#{src_dir}'."

    spec_location = File.join(location, 'Pindah.spec')
    spec_template = File.read(File.join(File.dirname(__FILE__), 
                                        '..', 'templates', 
                                        'Pindah.spec'))

    File.open(spec_location, 'w') do |f|
      f.puts spec_template.gsub(/PROJECT_NAME/, segments[-1]).
        gsub(/API_TARGET/, DEFAULT_TARGET).
        gsub(/API_VERSION/, DEFAULT_VERSION)
    end
    log "Created Pindah spec file in '#{spec_location}'."


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
