module Clusta
  
  module Geometry

    def self.register_element klass, name=nil
      if name
        Wukong::RESOURCE_CLASS_MAP[name] = klass
      else
        klass.all_stream_names.each do |name|
          Wukong::RESOURCE_CLASS_MAP[name] = klass
        end
      end
    end

    Dir[File.join(File.dirname(__FILE__), "geometry/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload Clusta.classify(require_name), "clusta/geometry/#{require_name}"
    end

    Dir[File.join(File.dirname(__FILE__), "geometry/directed/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      autoload ("Directed" + Clusta.classify(require_name)), "clusta/geometry/directed/#{require_name}"
    end

  end
end
