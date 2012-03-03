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

    register_transform :Import,              'clusta/transforms/import'
    register_transform :EdgesToDegrees,      'clusta/transforms/edges_to_degrees'
    register_transform :EdgesToVertexArrows, 'clusta/transforms/edges_to_vertex_arrows'
    
    ARG_REGEXP = /--transform=[\w\d_]+/

    def self.from_arg arg
      from_name(arg.split('=').last)
    end

    def self.from_name name
      begin
        const_get(name.split('_').map(&:capitalize).join)
      rescue NameError => e
        raise Error.new("No such transform: '#{name}'")
      end
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
