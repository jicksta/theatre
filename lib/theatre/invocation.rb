require 'theatre/guid'

module Theatre
  
  ##
  # An Invocation is an object which Theatre generates and returns from Theatre#handle.
  #
  class Invocation
    
    attr_reader :queued_time, :started_time, :finished_time, :unique_id, :callback, :namespace, :error, :returned_value
    
    ##
    # Create a new Invocation.
    #
    # @param [String] namespace The "/foo/bar/qaz" path to the namespace to which this Invocation belongs.
    # @param [Proc] callback The block which should be executed by an Actor scheduler.
    # @param [Object] payload The message that will be sent to the callback for processing.
    #
    def initialize(namespace, callback, payload=:theatre_no_payload)
      @payload       = payload
      @unique_id     = new_guid.freeze
      @callback      = callback
      @current_state = :new
      @state_lock    = Mutex.new
    end
    
    def queued
      with_state_lock do
        return false unless @current_state == :new
        @current_state = :queued
        @queued_time = Time.now.freeze
      end
      true
    end
    
    def current_state
      with_state_lock { @current_state }
    end
    
    def start
      with_state_lock do
        return false unless @current_state == :queued
        @current_state = :running
      end
      
      @started_time = Time.now.freeze
      
      begin
        @returned_value = if @payload.equal? :theatre_no_payload
          @callback.call
        else
          @callback.call @payload
        end
        with_state_lock { @current_state = :success }
      rescue => @error
        with_state_lock { @current_state = :error }
      ensure
        @finished_time = Time.now.freeze
      end
    end
    
    def execution_duration
      return nil unless @finished_time
      @finished_time - @started_time
    end
    
    def error?
      current_state.equal? :error
    end
    
    def success?
      current_state.equal? :success
    end
    
    ##
    # When this Invocation has been queued, started, and entered either the :success or :error state, this method will
    # finally return. Until then, it blocks the Thread.
    #
    def wait
      raise NotImplementedError
    end
    
    protected
    
    def with_state_lock(&block)
      @state_lock.synchronize(&block)
    end
    
  end
end
