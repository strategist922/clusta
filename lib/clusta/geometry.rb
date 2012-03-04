module Clusta
  
  module Geometry

    autoload :Element, 'clusta/geometry/element'

    ELEMENTS = []

    def self.register_geometry name, path, geometries=nil
      autoload name, path
      self::ELEMENTS << name
    end

    Dir[File.join(File.dirname(__FILE__), "geometry/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      register_geometry Clusta.classify(require_name), "clusta/geometry/#{require_name}"
    end

    Dir[File.join(File.dirname(__FILE__), "geometry/directed/*.rb")].each do |path|
      require_name = Clusta.require_name(path)
      register_geometry ("Directed" + Clusta.classify(require_name)), "clusta/geometry/directed/#{require_name}"
    end

  end
end
