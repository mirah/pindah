require 'fileutils'

module PindahCLI
  def self.log(msg)
    STDERR.puts msg
  end
  
  def self.create(namespace, location, activity_name=nil)
    segments = namespace.split('.')
    src_dir  = File.join(location, 'src', *segments)
    FileUtils.mkdir_p src_dir
    log "Created '#{src_dir}'."
    if activity_name
      activity_location = File.join(src_dir, "#{activity_name}.mirah")
      template = File.read(File.join(File.dirname(__FILE__),
                                     '..', 'templates',
                                     'initial_activity.mirah'))

      File.open(activity_location, 'w') do |f|
        f.puts template.gsub(/INITIAL_ACTIVITY/, activity_name)
      end
      log "Created Activity '#{activity_name}' in '#{activity_location}'."
    end
  end
end
