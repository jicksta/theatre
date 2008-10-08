begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files = ['lib/**/*.rb'] + %w[README.markdown TODO.markdown LICENSE]
  end
rescue LoadError
  STDERR.puts "\nCould not require() YARD! Install with 'gem install yard' to get the 'yardoc' task\n\n"
end

require 'rake/gempackagetask'
require 'rubygems'
require 'spec/rake/spectask'

SPEC_GLOB = 'spec/**/*_spec.rb'
GEMSPEC   = eval File.read("theatre.gemspec")

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = Dir[*SPEC_GLOB]
    t.output_dir = 'coverage'
    t.verbose = true
    t.rcov_opts.concat %w[--sort coverage --sort-reverse -x gems -x /var --no-validator-links]
  end
rescue LoadError
  STDERR.puts "Could not load rcov tasks -- rcov does not appear to be installed. Continuing anyway."
end

Rake::GemPackageTask.new(GEMSPEC).define

desc "Run all RSpecs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList[SPEC_GLOB]
end

desc "Compares Theatre's files with those listed in theatre.gemspec"
task :check_gemspec_files do
  
  files_from_gemspec    = THEATRE_FILES
  files_from_filesystem = Dir.glob(File.dirname(__FILE__) + "/**/*").map do |filename|
    filename[0...Dir.pwd.length] == Dir.pwd ? filename[(Dir.pwd.length+1)..-1] : filename
  end.sort
  files_from_filesystem.reject! { |f| File.directory? f }
  
  puts
  puts 'Pipe this command to "grep -v \'spec/\'" to ignore spec files'
  puts
  puts '##########################################'
  puts '## Files on filesystem not in the gemspec:'
  puts '##########################################'
  puts((files_from_filesystem - files_from_gemspec).map { |f| "  " + f })
  
  
  puts '##########################################'
  puts '## Files in gemspec not in the filesystem:'
  puts '##########################################'
  puts((files_from_gemspec - files_from_filesystem).map { |f| "  " + f })
end

desc "Test that the .gemspec file executes"
task :debug_gem do
  require 'rubygems/specification'
  gemspec = File.read('adhearsion.gemspec')
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n#{gemspec}") }.join
  puts "SUCCESS: Gemspec runs at the $SAFE level 3."
end
