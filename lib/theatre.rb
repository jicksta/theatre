require 'thread'
require 'rubygems'

begin
  require File.dirname(__FILE__) + "/../support/aasm/lib/aasm.rb"
rescue LoadError
  abort 'Could not require() AASM! Did you do type "git submodule update --init" to download it?'
end

$: << File.expand_path(File.dirname(__FILE__))

require 'theatre/version'
require 'theatre/namespace_manager'
require 'theatre/invocation'
# require 'theatre/erlang_calculator'

module Theatre
  
  class Theatre
    
    def initialize(thread_count=6)
      @thread_count      = thread_count
      @started           = false
      @namespace_manager = ActorNamespaceManager.new
      @thread_group      = ThreadGroup.new
      @master_queue      = Queue.new
    end
    
    ##
    # Send a message to this Theatre for processing.
    #
    # @param [String] namespace The namespace to which the payload should be sent
    # @param [Object] payload The actual content to be sent to the callback
    # @raise Theatre::NamespaceNotFound Raised when told to enqueue an unrecognized namespace
    def handle(namespace, payload)
      callback   = NamespaceManager.callbacks_for_namespace(namespace)
      invocation = Invocation.new(payload, namespace, callback)
      
      @master_queue << payload
    end
    
    ##
    # Starts this Theatre.
    #
    # When this method is called, the Threads are spawned and begin pulling messages off this Theatre's master queue.
    def start!
      @thread_count.times do
        @thread_group.add Thread.new(&method(:thread_loop))
      end
    end
    
    ##
    # Notifies all Threads for this Theatre to stop by sending them special messages. Any messages which were queued and
    # unhandled when this method is received will still be processed. Note: you may start this Theatre again later once it
    # has been stopped.
    def graceful_stop!
      @thread_count.times { @master_queue << :THEATRE_SHUTDOWN! }
    end
    
    protected
    
    def warn(message)
      # Not really implemented yet.
    end
    
    def thread_loop
      loop do
        begin
          next_invocation = @master_queue.pop
          return :stopped if next_invocation.equal? :THEATRE_SHUTDOWN!
          next_invocation.start
        rescue => error
          warn error
        end
      end
    end
    
  end
  
end
