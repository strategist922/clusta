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
      script  = defined?(transform::Script) ? transform::Script : default_script
      script.new(mapper, reducer, options)
    end

    def self.default_script
      Class.new(Wukong::Script).tap do |c|
        c.class_eval do
          def local_mode_sort_commandline
            "sort -n -k2"
          end
        end
      end
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

    def self.listing
      [].tap do |out|
        out << "Known transforms:"
        out << ''
        names.sort.each do |transform_name|
          transform = from_name(transform_name)
          name_suffix = case
                        when has_mapper?(transform)     && has_reducer?(transform)     then ''
                        when (! has_mapper?(transform)) && has_reducer?(transform)     then ' (reduce-only)'
                        when has_mapper?(transform)     && (! has_reducer?(transform)) then ' (map-only)'
                        when (! has_mapper?(transform)) && (! has_reducer?(transform)) then ' (nothing)'
                        end
          
          out << "  #{transform_name}#{name_suffix}"
          if transform.respond_to?(:help)
            out << ''
            out << "    #{transform.help}"
          end
          out <<  ''
        end
      end.join("\n")
    end

    def self.load_from path
      class_eval(File.read(path), path)
      register_transform(Clusta.require_name(path))
    end
    
  end
  
end
