require File.dirname(__FILE__) + "/spec_helper"

describe "Theatre::Theatre" do
  it "should start the quantity of threads given to its constructor" do
    number_of_threads = 13
    theatre = Theatre::Theatre.new(number_of_threads)
    
    flexmock(Thread).should_receive(:new).times(number_of_threads).and_return
    flexstub(theatre.send(:instance_variable_get, :@thread_group)).should_receive(:add).and_return
    
    theatre.start!
  end
  
  describe '#thread_loop' do
    
    it "should continue looping even after an exception been raised" do
      mock_invocation = flexmock "mock Invocation which raises when started"
      mock_invocation.should_receive(:start).once.and_raise ArgumentError # Simulate logic error
      
      theatre = Theatre::Theatre.new
      master_queue = theatre.send(:instance_variable_get, :@master_queue)
      flexmock(theatre).should_receive(:loop).once.and_yield
      flexmock(master_queue).should_receive(:pop).once.and_return mock_invocation
      
      lambda do
        theatre.send(:thread_loop).should equal(:stopped)
      end.should_not raise_error(ArgumentError)
    end
    
    it "should run the callback of the Invocation it receives from the master_queue" do
      has_executed = false
      thrower    = lambda { has_executed = true }
      namespace  = "/foo/bar"
      payload    = [1,2,3]
      
      invocation = Theatre::Invocation.new(namespace, thrower, payload)
      invocation.queued
      
      theatre = Theatre::Theatre.new
      
      master_queue = theatre.send(:instance_variable_get, :@master_queue)
      
      flexmock(theatre).should_receive(:loop).and_yield
      flexmock(master_queue).should_receive(:pop).once.and_return invocation
      
      theatre.send :thread_loop
      
      has_executed.should equal(true)
    end
    
    it "should stop when receiving the shutdown command and return :stopped" do
      theatre = Theatre::Theatre.new
      master_queue = theatre.send(:instance_variable_get, :@master_queue)
      flexmock(theatre).should_receive(:loop).once.and_yield
      flexmock(master_queue).should_receive(:pop).once.and_return :THEATRE_SHUTDOWN!
      theatre.send(:thread_loop).should equal(:stopped)
    end
    
  end
  
end
