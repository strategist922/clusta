module Clusta
  module Geometry
    
    class DirectedNeighborhood < Neighborhood
      
      def directed?
        true
      end

      def degree_pairs
        neighbors.map do |neighbor|
          # This vertex's in-degree is not known to us; we just have
          # its out-degree based on the size of this neighborhood.
          #
          # We don't know anything about each neighbor's degree than
          # its in-degree is at least 1 b/c it's in this vertex's
          # neighborhood.
          DirectedDegreePair.new(label, neighbor.label, 0, size, 1, 0)
        end
      end

      def reversed_degree_pairs
        neighbors.map do |neighbor|
          DirectedDegreePair.new(neighbor.label, label, 1, 0, 0, size)
        end
      end
      
    end
    
  end
end
