module Clusta
  module Geometry
    
    class VertexArrows < Vertex
      
      input_fields :arrows

      def directed?
        false
      end

      def joins? target_label
        arrows.detect { |arrow| arrow.target_label == target_label }
      end

      def degree
        arrows.size
      end
      
    end
    
  end
end
