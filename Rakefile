require 'rubygems'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'tasks/release.rb'

class GemVersion
  VERSION = "0.2.0"
end

spec = Gem::Specification.new do |s|
  s.name = "hiera-puppet"
  # Tag the version you want to release via an annotated tag
  s.version = described_version
  s.author = "R.I.Pienaar"
  s.email = "rip@devco.net"
  s.homepage = "https://github.com/ripienaar/hiera-puppet"
  s.platform = Gem::Platform::RUBY
  s.summary = "Puppet query interface and backend for Hiera"
  s.description = "Store and query Hiera data from Puppet"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["spec/**/*test.rb"].to_a
  s.has_rdoc = true
  s.add_dependency 'hiera', '~>0.2.0'
  s.executables = "extlookup2hiera"
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = File.read("spec/spec.opts").chomp || ""
end

task :default => [:test, :repackage]
