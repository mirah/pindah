# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'pindah' do |h|
  developer('Phil Hagelberg', 'technomancy@gmail.com')
  h.url = "http://github.com/mirah/pindah"
  h.readme_file = "README.md"
  h.summary = "A tool for writing Android applications in Mirah"
  extra_deps << ["mirah", ">= 0.0.10"]
end

# vim: syntax=ruby

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*.rb']
  t.verbose = true
end
