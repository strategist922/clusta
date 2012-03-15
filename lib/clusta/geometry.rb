module Clusta
  
  module Geometry

    def self.names
      @names ||= {}
    end

    def self.register_element klass, name=nil
      if name
        Wukong::RESOURCE_CLASS_MAP[name] = klass
      else
        klass.all_stream_names.each do |name|
          Wukong::RESOURCE_CLASS_MAP[name] = klass
        end
      end
    end

    def self.from_name name
      begin
        const_get(Clusta.classify(name))
      rescue NameError => e
        raise Error.new("No such transform: '#{name}'")
      end
    end
    
    Dir[File.join(File.dirname(__FILE__), "geometry/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload Clusta.classify(require_name), "clusta/geometry/#{require_name}"
      names[require_name] ||= {} unless require_name == 'all'
    end

    Dir[File.join(File.dirname(__FILE__), "geometry/directed/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload ("Directed" + Clusta.classify(require_name)), "clusta/geometry/directed/#{require_name}"
      names[require_name] ||= {}
      names[require_name][:directed] = true
    end

    def self.listing
      [].tap do |out|
        out << "Known geometries:"
        out << ''
        names.keys.sort.each do |element_name|
          element = from_name(element_name)
          if names[element_name][:directed]
            directed_element = from_name("directed_#{element_name}")
          else
            directed_element = nil
          end
          
          out << "  #{element}"
          stream_names = element.all_stream_names.sort
          stream_names.concat(directed_element.all_stream_names.sort) if directed_element
          out << "    streams as: #{stream_names.uniq.join(', ')}"
          out << ''
        end
      end.join("\n")
    end

    def self.load_from path
      class_eval(File.read(path), path)
      require_name = Clusta.require_name(path)
      names[require_name] ||= {}
      names[require_name][:directed] = true if require_name =~ /^directed_/
    end
    
    
  end
end
