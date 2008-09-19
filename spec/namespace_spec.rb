require File.dirname(__FILE__) + "/spec_helper"

describe "ActorNamespaceManager" do
  
  it "should make a registered namespace findable once registered" do
    nm = Theatre::ActorNamespaceManager.new
    nm.register_namespace_name "/foo/bar/qaz"
    nm.search_for_namespace("/foo/bar/qaz").should be_kind_of(Theatre::ActorNamespaceManager::NamespaceNode)
  end
end

describe "NamespaceNode" do
  
  it "when registering a new namespace, the new NamespaceNode should be returned" do
    node.register_namespace_name("foobar").should be_instance_of(Theatre::NamespaceManager::NamespaceNode)
  end
  
  it "should not blow away an existing callback when registering a new one with the same name" do
    name = "blah"
    node = Theatre::NamespaceManager::NamespaceNode.new
    node.register_namespace_name name
    before = node.child_named(name)
    before.should be_instance_of(Theatre::NamespaceManager::NamespaceNode)
    node.register_namespace_name name
    before.should eql(node.child_named(name))
  end
end

describe Theatre::EventNamespace do
  
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