require 'fileutils'
require 'erb'

module PindahCLI
  DEFAULT_TARGET = 'android-7'
  DEFAULT_VERSION = 'android-2.1'

  def self.log(msg)
    STDERR.puts msg
  end

  def self.create_templated(name, project_location, scope)
    location = File.join(project_location, name)
    template = File.read(File.join(File.dirname(__FILE__), 
                                   '..', 'templates', name))

    File.open(location, 'w') do |f|
      f.puts ERB.new(template).result(scope)
    end
  end
  
  def self.create(package, location, activity_name=nil)
    segments = package.split('.')
    src_dir  = File.join(location, 'src', *segments)
    name = location.split("/").last

    FileUtils.mkdir_p src_dir

    create_templated("Rakefile", location, binding)
    create_templated("AndroidManifest.xml", location, binding)

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
