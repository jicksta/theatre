require 'rubygems'

desc "Run RSpec specs"
task :spec do
  spec_dir   = File.expand_path File.dirname(__FILE__) + "/spec"
  spec_files = Dir[spec_dir + "/**/*_spec.rb"]
  spec_files.each { |file| require file }
end
