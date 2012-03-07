module Clusta

  module Transforms

    Dir[File.join(File.dirname(__FILE__), "transforms/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload Clusta.classify(require_name), "clusta/transforms/#{require_name}"
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
  
end
