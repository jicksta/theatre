require 'thread'
require 'rubygems'

begin
  require File.dirname(__FILE__) + "/../support/aasm/lib/aasm.rb"
rescue LoadError
  abort 'Could not require() AASM! Did you do type "git submodule update --init" to download it?'
end

$: << File.expand_path(File.dirname(__FILE__))

require 'theatre/version'
require 'theatre/namespace'
require 'theatre/invocation'
# require 'theatre/erlang_calculator'

module Theatre
  
  class Theatre
    
    def initialize(thread_count)
      @thread_count      = thread_count
      @started           = false
      # @calculator        = ErlangCalculator.new
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
    
    def start!
      @thread_count.times do
        @thread_pool.add Thread.new(&method(:thread_loop))
      end
    end
  
    protected
    
    def thread_loop
      loop do
        begin
          invocation = @master_queue.pop
          invocation.start
        rescue => e
          puts e.inspect, *e.backtrace
        end
      end
    end
    
  end
  
end
