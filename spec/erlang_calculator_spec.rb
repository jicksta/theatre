require File.dirname(__FILE__) + "/spec_helper"

KNOWN_CALCULATIONS = {
  { :calls_per_hour => 1000,
    :call_duration  => 10,
    :average_delay  => 1
  } => 5,
  { :calls_per_hour => 1234,
    :call_duration  => 100,
    :average_delay  => 10
  } => 39,
  { :calls_per_hour => 55,
    :call_duration  => 120,
    :average_delay  => 90
  } => 3,
  { :calls_per_hour => 60,
    :call_duration  => 1000,
    :average_delay  => 600
  } => 18,
  { :calls_per_hour => 123,
    :call_duration  => 456,
    :average_delay  => 78
  } => 19,
  { :calls_per_hour => 1,
    :call_duration  => 10,
    :average_delay  => 1
  } => 1
}

describe "ErlangCalculator" do
  
  describe "::b" do
    it "should agree known calculations" do
      KNOWN_CALCULATIONS.each_pair do |parameters, value|
        Theatre::ErlangCalculator.b(parameters).should eql(value)
      end
    end
    
  end
  
  describe "::c" do
    
    Theatre::ErlangCalculator.c
  end
  
end
