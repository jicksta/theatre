require 'theatre/namespace'

module Theatre
  
  class ActorNamespaceManager

    VALID_NAMESPACE = %r{^(/[\w_]+)+$}
    
    class << self
      def valid_namespace_path?(namespace_path)
        namespace_path =~ VALID_NAMESPACE
      end
    end
    
    def initialize
      @dictionary_lock = Mutex.new
    end
    
    ##
    # Registers a new namespace path with this ActorNamespaceManager
    #
    def register_namespace(*paths)
      raise 
    end
    
    def unregister_namespace
    
    end
    
    def callbacks_for_namespace
      
    end
    
  end
  
  
  class InvalidNamespacePath < Exception
    def initialize(path)
      super "Path #{path.inspect} is not a valid namespace!"
    end
  end
  
  class NamespaceNotFound < Exception
  end
  
end