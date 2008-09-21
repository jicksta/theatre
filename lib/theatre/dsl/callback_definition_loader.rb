module Theatre
  
  ##
  # New instances of this class make
  #
  class CallbackDefinitionLoader
    
    class << self
      
      ##
      # Parses the given Ruby source code file and returns a new CallbackDefinitionLoader.
      #
      # @param [String, File] file The filename or File object for the Ruby source code file to parse.
      #
      def from_file(file)
        new.load_events_file(file)
      end
      
      ##
      # Parses the given Ruby source code and returns a new CallbackDefinitionLoader.
      #
      # NOTE: Only use this if you're generating the code yourself! If you're loading a file from the filesystem, you should
      # use from_file() since from_file will properly attribute errors in the code to the file from which the code was 
      # loaded.
      #
      # @param [String] code The Ruby source code to parse
      #
      def from_events_code(code)
        new.load_code code
      end
    end
    
    attr_reader :root_name
    def initialize(root_name=:events)
      @root_name = root_name
      @callbacks = []
      create_recorder_method root_name
    end
    
    ##
    # Converts all definitions this object has received into a two dimensional Array.
    #
    # The second dimension is in the format ["/some/namespace/here", (the Proc callback)]
    #
    def normalize!
      @callbacks
    end
    
    def anonymous_recorder
      BlankSlateMessageRecorder.new(&method(:callback_registered))
    end
    
    ##
    # Parses the given Ruby source code file and returns this object.
    #
    # @param [String, File] file The filename or File object for the Ruby source code file to parse.
    #
    def load_events_file(file)
      file = File.open(file) if file.kind_of? String
      instance_eval file.read, file.path
      self
    end
    
    ##
    # Parses the given Ruby source code and returns this object.
    #
    # NOTE: Only use this if you're generating the code yourself! If you're loading a file from the filesystem, you should
    # use load_events_file() since load_events_file() will properly attribute errors in the code to the file from which the
    # code was loaded.
    #
    # @param [String] code The Ruby source code to parse
    #
    def load_events_code(code)
      instance_eval code
      self
    end
    
    protected
    
    def callback_registered(namespaces, callback)
      # namespaces looks like [:foobar, 123]
      @callbacks << [namespaces, callback]
    end
    
    def create_recorder_method(record_method_name)
      (class << self; self; end).send(:alias_method, record_method_name, :anonymous_recorder)
    end
    
    class BlankSlateMessageRecorder
      
      (instance_methods - %w[__send__ __id__]).each { |m| undef_method m }
      
      def initialize(&notify_on_completion)
        @notify_on_completion = notify_on_completion
        @namespaces = []
      end
      
      def method_missing(*method_name_and_args)
        raise ArgumentError, "Supplying a block is not supported" if block_given?
        @namespaces << method_name_and_args
        self
      end
      
      def each(&callback)
        @notify_on_completion.call(@namespaces, callback)
      end
      
    end
    
  end
end