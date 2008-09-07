begin
  require File.dirname(__FILE__) + "/support/yard/lib/yard.rb"
rescue LoadError
  abort 'Could not require() YARD! Did you do type "git submodule update --init" to download it?'
end

require 'rubygems'
require 'spec/rake/spectask'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  # t.options = ['--any', '--extra', '--opts'] # optional
end

desc "Run all RSpecs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end