require 'theatre/guid'

module Theatre
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
    
    attr_reader :queued_time, :unique_id, :callback
    def initialize(callback)
      @unique_id = new_guid.freeze
      @callback  = callback
    end
    
    def current_state
      aasm_current_state
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