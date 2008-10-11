require File.dirname(__FILE__) + "/spec_helper"

describe "Theatre::Theatre" do
  
  it "should start the quantity of threads given to its constructor" do
    number_of_threads = 13
    theatre = Theatre::Theatre.new(number_of_threads)
    
    flexmock(Thread).should_receive(:new).times(number_of_threads).and_return
    flexstub(theatre.send(:instance_variable_get, :@thread_group)).should_receive(:add).and_return
    
    theatre.start!
  end
  
  it "should not spawn new threads when calling start twice" do
    number_of_threads = 5
    
    theatre = Theatre::Theatre.new(number_of_threads)
    
    threads = Array.new(number_of_threads) { Thread.new(&theatre.method(:thread_loop)) }
    flexmock(Thread).should_receive(:new).times(number_of_threads).and_return *threads
    
    theatre.start!
    theatre.start!
    theatre.start!
    theatre.start!
    theatre.graceful_stop!
  end
  
  describe '#trigger' do
    
    it "should properly execute the block given" do
      
      has_ran = false
      
      theatre = Theatre::Theatre.new
      theatre.register_namespace_name "cheezburger"
      theatre.register_callback_at_namespace "cheezburger", lambda { |payload| has_ran = payload }
      
      theatre.start!
      
      theatre.trigger "cheezburger", :yes
      theatre.graceful_stop!
      theatre.join
      
      has_ran.should equal(:yes)
    end
    
    it "should return an Array of Invocation objects" do
      theatre = Theatre::Theatre.new
      theatre.register_namespace_name "qaz"
      theatre.register_callback_at_namespace "qaz", lambda {}
      return_value = theatre.trigger("qaz")
      return_value.should be_instance_of(Array)
      return_value.should have(1).item
      return_value.first.should be_instance_of(Theatre::Invocation)
    end
    
  end
  
  describe '#callbacks_for_namespaces' do
    it "should properly return Procs which have been registered against a namespace" do
      callback = lambda { :callback }
      theatre = Theatre::Theatre.new
      theatre.register_namespace_name "pumpkin"
      theatre.register_callback_at_namespace "pumpkin", callback
      theatre.namespace_manager.callbacks_for_namespaces("pumpkin").should eql([callback])
    end
  end
  
  describe '#join' do
    it "should execute join() on every ThreadGroup thread" do
      thread_mocks = Array(3) do
        bogus_thread = flexmock "bogus thread"
        bogus_thread.should_receive(:join).once.and_return
        bogus_thread
      end
      bogus_thread_group = flexmock "A ThreadGroup which returns an Array of mock Threads", :list => thread_mocks
      theatre = Theatre::Theatre.new
      theatre.send(:instance_variable_set, :@thread_group, bogus_thread_group)
      theatre.join
    end
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
