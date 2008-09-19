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
  
  it "should pass the payload to the callback" do
    destined_payload = [:i_feel_so_pretty, :OH, :SO, :PRETTY!]
    expecting_callback = lambda do |payload|
      payload.should equal(destined_payload)
    end
    invocation = Theatre::Invocation.new("/namespace/whatever", expecting_callback, destined_payload)
    invocation.queued
    invocation.start
  end
  
  it "should have a status of :error if an exception was raised and set the #error property" do
    errorful_callback = lambda { raise ArgumentError } # Simulate logic error
    invocation = Theatre::Invocation.new("/namespace/whatever", errorful_callback)
    invocation.queued
    invocation.start
    invocation.current_state.should equal(:error)
    invocation.should be_error
    invocation.error.should be_instance_of(ArgumentError)
  end

  it "should have a status of :success if no expection was raised" do
    callback = lambda { "No errors raised here!" }
    invocation = Theatre::Invocation.new("/namespace/whatever", callback)
    invocation.queued
    invocation.start
    invocation.current_state.should equal(:success)
    invocation.should be_success
  end
  
end

BEGIN {
  module InvocationTestHelper
    def new_invocation
      Theatre::Invocation.new(@namespace, @block, @payload)
    end
  end
}