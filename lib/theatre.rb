require 'thread'
require 'rubygems'

$: << File.expand_path(File.dirname(__FILE__))

require 'theatre/version'
require 'theatre/namespace_manager'
require 'theatre/invocation'
require 'theatre/dsl/callback_definition_loader'

module Theatre
  
  class Theatre
    
    attr_reader :namespace_manager
    
    ##
    # Creates a new stopped Theatre. You must call start!() after you instantiate this for it to begin processing events.
    #
    # @param [Fixnum] thread_count Number of Threads to spawn when started.
    #
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
    #
    def handle(namespace, payload)
      callback   = NamespaceManager.callbacks_for_namespace(namespace)
      invocation = Invocation.new(namespace, callback, payload)
      
      @master_queue << payload
    end
    
    def load_events_code(code, *args)
      CallbackDefinitionLoader.new(self, *args).load_events_code(code)
    end
    
    def load_events_file(file, *args)
      CallbackDefinitionLoader.new(self, *args).load_events_file(file)
    end
    
    def join
      @thread_group.list.each do |thread|
        begin
          thread.join
        rescue
          # Ignore any exceptions
        end
      end
    end
    
    ##
    # Starts this Theatre.
    #
    # When this method is called, the Threads are spawned and begin pulling messages off this Theatre's master queue.
    #
    def start!
      return false if @thread_group.list.any? # Already started
      @started_time = Time.now
      @thread_count.times do
        @thread_group.add Thread.new(&method(:thread_loop))
      end
    end
    
    ##
    # Notifies all Threads for this Theatre to stop by sending them special messages. Any messages which were queued and
    # unhandled when this method is received will still be processed. Note: you may start this Theatre again later once it
    # has been stopped.
    #
    def graceful_stop!
      @thread_count.times { @master_queue << :THEATRE_SHUTDOWN! }
      @started_time = nil
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
