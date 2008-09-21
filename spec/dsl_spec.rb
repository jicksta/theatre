require File.dirname(__FILE__) + "/spec_helper"

describe "CallbackDefinitionContainer" do
  
  it "should successfully load the :simple_before_call example" do
    example = Example.new(:simple_before_call)
    loader  = Theatre::CallbackDefinitionLoader.from_file example.file
    normalized = loader.normalize!
    normalized.should have(1).item
    normalized.first.last.should be_instance_of(Proc)
    normalized.first.first.should == [[:asterisk], [:before_call]]
  end
  
  it "should let you override the recorder method name" do
    loader = Theatre::CallbackDefinitionLoader.new(:roflcopter)
    flexmock(loader).should_receive(:callback_registered).once
    loader.roflcopter.foo.bar.qaz.each {}
  end
  
end

# High level specs to test the entire library.

describe "Adhearsion-esque usages of Theatre" do
  it "should work with Asterisk before_call things" do
    channel = "SIP/jicksta-12bb32h1"
    example = Example.new(:simple_before_call).file
    pending "Coming soon"
    begin
      container.start!
      
      mock_call = flexmock "mock call"
      mock_call.should_receive(:[]).once.with(:channel).and_return channel
      
      container.handle "/asterisk/before_call", mock_call
    ensure
      container.graceful_stop!
    end
  end
end

describe "Stomp-esque usage of Theatre" do
  it "should make it easy to register new namespace listeners"
end