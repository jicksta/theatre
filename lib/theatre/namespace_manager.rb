require 'theatre/namespace'

module Theatre
  
  class ActorNamespaceManager

    VALID_NAMESPACE = %r{^(/[\w_]+)+$}
    
    class << self
      def valid_namespace_path?(namespace_path)
        namespace_path =~ VALID_NAMESPACE
      end
    end
    

    def initalize
      @registry_lock = Mutex.new
      @root          = NamespaceNode.new
    end

    ## 
    # Have this registry recognize a new path and prepare it for callback registrations
    #
    # @param [String, Array] paths The namespace to register. Can be in "/foo/bar" or *[foo,bar] format
    # @raise NamespaceNotFound if a segment has not been registered yet
    def register_namespace_name(*paths)
      search_for_namespace(paths[1...-1]).register_namespace_name paths.last
    end
    
    ##
    # Returns a Proc found after searching with the namespace you provide
    #
    # @raise NamespaceNotFound if a segment has not been registered yet
    def callback_for_namespaces(*paths)
      search_for_namespace(paths).callbacks
    end
    
    ##
    # Find a namespace in the tree.
    #
    # @param [Array] paths Must be an Array of segments
    # @raise NamespaceNotFound if a segment has not been registered yet
    def search_for_namespace(paths)
      paths = normalize_path_to_array paths
      path_string = "/"
      paths.inject(@root) do |last_node,this_node_name|
        raise NamespaceNotFound.new(path_string) unless last_node
        path_string << this_node_name
        @root.child_named(this_node_name)
      end
    end
    
    protected
    
    ##
    # Since there are a couple ways to represent namespaces, this is a helper method which will normalize
    # them into the most practical: an Array of Symbols
    # @param [String, Array] paths The namespace to register. Can be in "/foo/bar" or *[foo,bar] format
    def normalize_path_to_array(paths)
      paths = paths.flatten if paths.kind_of? Array
      paths = paths.split('/') if paths.kind_of? String
      paths.map { |path| path.to_sym }
    end
    
    ##
    # Used by NamespaceManager to build a tree of namespaces. Has a Hash of children which is not 
    # Thread-safe. For Thread-safety, all access should semaphore through the NamespaceManager.
    class NamespaceNode
      
      attr_reader :name
      def initialize(name)
        @name = name.freeze
        @children  = {}
        @callbacks = []
      end
      
      def register_namespace_name(name)
        @children[name] = NamespaceNode.new(name) unless @children.has_key? name
      end
      
      def register_callback(callback)
        @callbacks << callbacks
        callback
      end
      
      def callbacks
        @callbacks.clone
      end
      
      def delete_callback(callback)
        @callbacks.delete callback
      end
      
      def child_named(name)
        @children[name]
      end
      
      def destroy_namespace(name)
        @children.delete name
      end
      
    end
    
  end
  
  
  class NamespaceNotFound < Exception
    def initialize(full_path)
      super "Could not find #{full_path.inspect} in the namespace registry. Did you register it yet?"
    end
  end
  
end
