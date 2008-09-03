module Theatre
  
  module ErlangCalculator
    
    class << self
      
      def b(call_time, peak_calls, lines_available)
        call_time, peak_call, lines_available = call_time.to_f, peak_calls.to_f, lines_available.to_f
        a = (peak_calls * call_time) / 60
        n = lines_available
        u = 1
        i = 1
        while i <= n
          u += (a**i) / factorial(i)
          i += 1
        end
        (( a**n / factorial(n) ) / u + 0.005) * 100
      end
      
      def factorial(number)
        sum = 1
        1.upto number do |num|
          sum *= num
        end
        sum
      end
      
    end
    
    def initialize()
      @invocations = 0
      @peak_calls  = 0
    end
    
    def update_statistics(call_time, threads_waiting, threads_available)
      
    end
    
  end
  
end