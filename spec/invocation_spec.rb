require File.dirname(__FILE__) + "/spec_helper"

GUID_REGEXP = /^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/i

describe "The lifecycle of an Invocation" do

  include InvocationTestHelper
  
  before :all do
    @block   = lambda {}
    @payload = 123
    @namespace = "/some/namespace"
  end
  
  it "should have an initial state of :new" do
    new_invocation.current_state.should eql(:new)
  end
  
  it "should not have a @queued_time until state becomes :queued" do
    invocation = new_invocation
    invocation.queued_time.should eql(nil)
    invocation.queued
    invocation.queued_time.should be_instance_of(Time)
    invocation.current_state.should eql(:queued)
  end
  
  it "should have a valid guid when instantiated" do
    new_invocation.unique_id.should =~ GUID_REGEXP
  end
  
  it "should execute the callback when moving to the 'start' state" do
    flexmock(@block).should_receive(:call).once
    invocation = new_invocation
    invocation.queued
    invocation.start
  end
  
end

describe "Using Invocations that've been ran through the Theatre" do
  
  describe "While wait()ing, the Invocation" do
    it "should return false to success? and to error?"
    it "should return the callback's return value in wait()"
  end
end

BEGIN {
  module InvocationTestHelper
    def new_invocation
      Theatre::Invocation.new(@namespace, @block, @payload)
    end
  end
}