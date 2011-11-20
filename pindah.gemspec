# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pindah}
  s.version = "0.1.3.dev"
  s.date =  Time.now.strftime("%Y-%m-%d")
  s.authors = [%q{Phil Hagelberg}]
  s.email = [%q{technomancy@gmail.com}]
  s.summary = %q{A tool for writing Android applications in Mirah}
  s.description = %q{}
  s.homepage = %q{http://github.com/mirah/pindah}
  s.executables = ["pindah"]
  s.extra_rdoc_files = %w{History.txt Manifest.txt}
  s.files = File.readlines("Manifest.txt")
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.5"

  s.add_runtime_dependency("mirah", ">= 0.0.10.dev")
end
