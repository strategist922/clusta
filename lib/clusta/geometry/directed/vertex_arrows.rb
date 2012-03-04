module Clusta
  module Geometry
    
    class DirectedVertexArrows < VertexArrows
      
      def directed?
        true
      end

      def source_degrees
        [0, arrows.size]
      end

      def target_degrees
        [1, 0]
      end

      def edge_degree_pair source_label, target_label, *args
        DirectedEdgeDegreePair.new(source_label, target_label, *args)
      end
      
    end
    
  end
end
