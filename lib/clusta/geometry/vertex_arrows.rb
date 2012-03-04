module Clusta
  module Geometry
    
    class VertexArrows < Vertex
      
      input_fields :arrows

      def joins? target_label
        arrows.detect { |arrow| arrow.target_label == target_label }
      end

      def directed?
        false
      end

      def source_degrees
        [arrows.size]
      end

      def target_degrees
        [1]
      end

      def edge_degree_pair source_label, target_label, *args
        EdgeDegreePair.new(source_label, target_label, *args)
      end

      def edge_degrees_pairs
        sds = source_degrees
        arrows.map do |arrow|
          edge_degree_pair(label, arrow.target_label, *(sds + target_degrees))
        end
      end

      def reversed_edge_degree_pairs
        sds = source_degrees
        arrows.map do |arrow|
          edge_degree_pair(arrow.target_label, label, *(target_degrees + sds))
        end
      end
      
    end
    
  end
end
