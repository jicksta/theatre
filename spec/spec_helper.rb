require 'yaml'
require 'yaml/types'
require 'rubygems'
require 'spec'
require 'flexmock/rspec'

require File.dirname(__FILE__) + "/../lib/theatre.rb"

Spec::Runner.configure do |config|
  config.mock_with :flexmock
end

class Example
  attr_reader :name, :yaml, :metadata, :file
  def initialize(name)
    @name = name.to_sym
    @file = File.expand_path(File.dirname(__FILE__) + "/dsl_examples/#{name}.rb")
    @yaml = file_contents[/=begin YAML\n(.+?)\n=end/m, 1]
    @metadata = @yaml.nil? ? nil : YAML.load(@yaml)
  end
  
  def file_contents
    File.read @file
  end
  
end
