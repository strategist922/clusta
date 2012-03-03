module Clusta
  module Geometry
    
    class DirectedEdge < Edge
      
      def directed?
        true
      end

      def source_degree
        DirectedDegree.new(source_label, 0, 1)
      end

      def target_degree
        DirectedDegree.new(target_label, 1, 0)
      end

    end
    
  end
end
