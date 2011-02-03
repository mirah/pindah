# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'pindah' do
  developer('Phil Hagelberg', 'technomancy@gmail.com')
  readme_file = "README.md"
  extra_deps << ["mirah", ">= 0.0.5"]
end

# vim: syntax=ruby

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*.rb']
  t.verbose = true
end
