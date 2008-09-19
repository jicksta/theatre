require 'theatre/guid'

module Theatre
  
  ##
  # An Invocation is an object which Theatre generates and returns from Theatre#handle.
  class Invocation
    
    include AASM

    aasm_state :new
    aasm_state :queued
    aasm_state :running
    aasm_state :success
    aasm_state :error

    aasm_event :queued do
      transitions :from => :new, :to => :queued, :on_transition => :set_queued_time
    end
    
    aasm_event :start do
      transitions :from => :queued, :to => [:success, :error], :on_transition => :run!
    end
    
    aasm_event(:success) { transitions :from => :running, :to => :success }
    aasm_event(:error)   { transitions :from => :running, :to => :error }
    
    attr_reader :queued_time, :unique_id, :callback, :namespace
    
    ##
    # Create a new Invocation.
    #
    # @param [Object] payload
    # @param [String] namespace The "/foo/bar/qaz" path to the namespace to which this Invocation belongs.
    # @param [Proc] callback The block which should be executed by an Actor scheduler.
    def initialize(payload, namespace, callback)
      @payload   = payload
      @unique_id = new_guid.freeze
      @callback  = callback
    end
    
    def current_state
      aasm_current_state
    end
    
    ##
    # When this Invocation has been queued, started, and entered either the :success or :error state, this method will
    # finally return. Until then, it blocks the Thread.
    def wait
      raise NotImplementedError
    end
    
    protected
    
    def set_queued_time
      @queued_time = Time.now.freeze
    end
   
    def run!
      @callback.call
    end

  end
end
