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
  attr_reader :name, :code, :yaml, :metadata
  def initialize(name)
    @name = name.to_sym
    @code = File.read File.dirname(__FILE__) + "/dsl_examples/#{name}"
    @yaml = @code[/=begin YAML\n(.+?)\n=end/m, 1]
    @metadata = @yaml.nil? ? nil : YAML.load(@yaml)
  end
end
