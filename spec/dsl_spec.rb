require File.dirname(__FILE__) + "/spec_helper"

describe "CallbackDefinitionContainer" do
  
  it "should successfully load the :simple_before_call example" do
    example = Example.new(:simple_before_call)
    theatre = Theatre::Theatre.new
    example.register_namespaces_on theatre
    
    flexmock(theatre.namespace_manager).should_receive(:register_callback_at_namespace).
        with([:asterisk, :before_call], Proc).once
    
    loader  = Theatre::CallbackDefinitionLoader.new(theatre)
    loader.load_events_file example.file
  end
  
  it "should let you override the recorder method name" do
    theatre = Theatre::Theatre.new
    theatre.namespace_manager.register_namespace_name "/foo/bar/qaz"
    flexmock(theatre.namespace_manager).should_receive(:register_callback_at_namespace).
        with([:foo, :bar, :qaz], Proc).once
    
    loader = Theatre::CallbackDefinitionLoader.new(theatre, :roflcopter)
    loader.roflcopter.foo.bar.qaz.each {}
  end
  
end

# High level specs to test the entire library.

describe "Adhearsion-esque usages of Theatre" do
  it "should work with Asterisk before_call things" do
    channel = "SIP/jicksta-12bb32h1"
    example = Example.new(:simple_before_call).file
    pending "need to think stuff out more"
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

describe "Misuses of the Theatre" do
  
  it "should not allow callbacks to be registered for namespaces which have not been registered" do
    theatre = Theatre::Theatre.new
    example = Example.new(:simple_before_call)
    
    loader = Theatre::CallbackDefinitionLoader.new(theatre)
    lambda do
      loader.events.foo.each {}
    end.should raise_error(Theatre::NamespaceNotFound)
  end
  
end
