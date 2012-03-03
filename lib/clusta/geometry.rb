module Clusta
  
  module Geometry

    autoload :Element, 'clusta/geometry/element'

    ELEMENTS = []

    def self.register_geometry name, path, geometries=nil
      autoload name, path
      self::ELEMENTS << name
    end

    register_geometry :Vertex,         'clusta/geometry/vertex'
    register_geometry :Edge,           'clusta/geometry/edge'
    register_geometry :DirectedEdge,   'clusta/geometry/directed_edge'
    register_geometry :Degree,         'clusta/geometry/degree'
    register_geometry :DirectedDegree, 'clusta/geometry/directed_degree'
    register_geometry :VertexArrows,   'clusta/geometry/vertex_arrows'
    register_geometry :Arrow,          'clusta/geometry/arrow'

  end
end
