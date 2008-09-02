require 'thread'
module Theatre
  class EventNamespace
    
    STATES        = [:active, :destroyed]
    INITIAL_STATE =  :active
    
    def initialize
      @state = INITIAL_STATE
      @queue = Queue.new
    end
    
  end
end
