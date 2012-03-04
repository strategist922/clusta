module Clusta
  module Geometry
    
    class Neighborhood < Vertex
      
      input_fields :neighbors

      def joins? label
        neighbors.detect { |neighbor| neighbor.label == label }
      end

      def directed?
        false
      end

      def size
        neighbors.size
      end

      def degree_pairs
        neighbors.map do |neighbor|
          # This vertex's degree is just the size of this
          # neighborhood.
          # 
          # We don't know anything about each neighbor's degree other
          # than it must be at least 1 b/c it's in this vertex's
          # neighborhood.
          DegreePair.new(label, neighbor.label, size, 1)
        end
      end

      def reversed_degree_pairs
        neighbors.map do |neighbor|
          DegreePair.new(neighbor.label, label, 1, size)
        end
      end
      
    end
    
  end
end
