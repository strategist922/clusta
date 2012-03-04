module Clusta

  module Transforms

    def self.register_streamable klass, aliases=nil
      (aliases || [klass.to_s]).each do |klass_alias|
        Wukong::RESOURCE_CLASS_MAP[klass_alias] = klass
      end
    end

    def self.register_transform name, path
      autoload name, path
    end

    Dir[File.join(File.dirname(__FILE__), "transforms/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      register_transform Clusta.classify(require_name), "clusta/transforms/#{require_name}"
    end
    
    ARG_REGEXP = /--transform=[\w\d_]+/

    def self.from_arg arg
      from_name(arg.split('=').last)
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
      Wukong::Script.new(mapper, reducer)
    end
    
  end

  Geometry::ELEMENTS.each do |element_name|
    Transforms.register_streamable Geometry.const_get(element_name), [
       "Clusta::Geometry::#{element_name}",
       "Geometry::#{element_name}",
       element_name.to_s
      ]
  end
  
end
