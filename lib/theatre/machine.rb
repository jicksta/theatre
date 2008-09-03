require 'theatre/erlang_calculator'

module Theatre
  
  class Theatre
    
    def initialize
      @calculator        = ErlangCalculator.new
      @namespace_manager = NamespaceManager.new
      @thread_pool       = ThreadPool.new
      @master_queue      = Queue.new
    end
    
    ##
    #
    # Send a message to this Theatre for processing.
    #
    # @param [String] namespace The namespace to which the payload should be sent
    # @param [Object]
    # @raise Theatre::NamespaceNotFound Raised when told to enqueue an unrecognized namespace
    def handle(namespace, payload)
      callback = NamespaceManager.callback_for_namespace(namespace)
      @master_queue << payload
    end
    
  end
  
end
