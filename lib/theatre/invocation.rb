module Theatre
  class Invocation
    
    include AASM

    aasm_state :new
    aasm_state :queued
    aasm_state :running
    aasm_state :success
    aasm_state :error

    aasm_event :enqueue do
      transitions :from => :new, :to => :queued, :on_transition => :set_queued_time
    end
    
    aasm_event :start do
      transitions :from => :queued, :to => [:success, :error]
    end
    
    aasm_event(:success) { transitions :from => :running }
    aasm_event(:error)   { transitions :from => :running }
    
    attr_reader :queued_time
    def initialize
      
    end
    
    def current_state
      aasm_current_state
    end
    
    protected
    
    def set_queued_time
      @queued_time = Time.now.freeze
    end
    
  end
end