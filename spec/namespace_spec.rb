require File.dirname(__FILE__) + "/spec_helper"

describe "NamespaceManager" do
  
  include NamespaceHelper
  
  describe "a valid namespace path" do
    
    it "should require a namespace path start with a /" do
      "/foo".   should     be_valid_actor_event_namespace
      "foo".    should_not be_valid_actor_event_namespace
      "foo/bar".should_not be_valid_actor_event_namespace
    end
    
    it "should allow multiple namespace segments" do
      "/foo_foo/bar".should be_valid_actor_event_namespace
    end
    
    it "should not allow a trailing forward slash" do
      "/foo/bar/".should_not be_valid_actor_event_namespace
    end
    
    it "should not allow backslashes" do
      '\foo'.should_not be_valid_actor_event_namespace
      '\foo\bar'.should_not be_valid_actor_event_namespace
      'foo\bar'.should_not be_valid_actor_event_namespace
      '\bar\\'.should_not be_valid_actor_event_namespace
    end
    
    it "should not allow weird characters" do
      %w[ ! @ # $ % ^ & * ( ) { } | ' : ? > < - = ].each do |bad_character|
        "/foo#{bad_character}foo/bar".should_not be_valid_actor_event_namespace
      end
    end
    
  end
end

describe "an EventNamespace" do
  
end

BEGIN {
module NamespaceHelper
  class BeValidNamespace
    
    def matches?(target)
      @target = target
      Theatre::ActorNamespaceManager.valid_namespace_path? target
    end
    
    def failure_message
      "expected #{@target.inspect} to be a valid namespace"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} not to be a valid namespace"
    end
    
  end
  
  def be_valid_actor_event_namespace
    BeValidNamespace.new
  end
  
end
}