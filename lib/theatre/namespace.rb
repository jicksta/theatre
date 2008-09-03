require 'thread'
module Theatre
  class EventNamespace
    
    def initialize
      @state = :active
      @queue = Queue.new
    end
    
  end
end
