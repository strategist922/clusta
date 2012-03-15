module Clusta

  module Transforms

    def self.names
      @names ||= []
    end
    
    def self.register_transform name
      names << name
    end

    def self.from_name name
      begin
        const_get(Clusta.classify(name))
      rescue NameError => e
        raise Error.new("No such transform: '#{name}'")
      end
    end

    def self.script_for transform
      mapper  = transform::Mapper  if defined?(transform::Mapper)
      reducer = transform::Reducer if defined?(transform::Reducer)
      options = (transform.respond_to?(:options) ? transform.options : {})
      script  = defined?(transform::Script) ? transform::Script : Wukong::Script
      script.new(mapper, reducer, options)
    end

    def self.has_mapper?(transform)
      defined?(transform::Mapper)
    end

    def self.has_reducer?(transform)
      defined?(transform::Reducer)
    end

    Dir[File.join(File.dirname(__FILE__), "transforms/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload Clusta.classify(require_name), "clusta/transforms/#{require_name}"
      register_transform require_name
    end
    
  end
  
end
