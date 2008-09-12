require File.dirname(__FILE__) + "/spec_helper"

describe "NamespaceManager" do
  it "should make a registered namespace findable once registered" do
    nm = Theatre::NamespaceManager.new
    nm.register_namespace_name "/foo/bar/qaz"
    nm.search_for_namespace("/foo/bar/qaz").should be_kind_of(Theatre::NamespaceManager::NamespaceNode)
  end
end

describe "NamespaceNode" do
  it "should not blow away an existing callback when registering a new one with the same name"
end

describe Theatre::EventNamespace do
  describe "enqueueing new messages" do
    
  end
end