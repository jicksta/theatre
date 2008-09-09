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
    it "should start each Invocation it receives"
    
    it "should continue looping even after an exception been raised" do
      raiser  = lambda { raise }
      
      theatre = Theatre::Theatre.new
      
      flexmock(theatre).should_receive(:loop).twice.and_yield
      
      theatre.handle
    end
  end
  
end
