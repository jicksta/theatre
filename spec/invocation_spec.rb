require File.dirname(__FILE__) + "/spec_helper"

describe "The lifecycle of an Invocation" do
  
  it "should have an initial state of :new" do
    Theatre::Invocation.new.current_state.should eql(:new)
  end
  
  it "should not have a @queued_time until state becomes :queued" do
    invocation = Theatre::Invocation.new
    invocation.queued_time.should eql(nil)
    invocation.queued!
    invocation.queued_time.should be_instance_of(Time)
    invocation.current_state.should eql(:queued)
  end
  
  it "should have a valid guid when instantiated" do
    Theatre::Invocation.new.unique_id.should =~ /^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/i
  end
  
end