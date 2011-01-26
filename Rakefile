# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'pindah' do
  developer('Phil Hagelberg', 'technomancy@gmail.com')
  extra_deps << "mirah"
end

# vim: syntax=ruby

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*.rb']
  t.verbose = true
end
