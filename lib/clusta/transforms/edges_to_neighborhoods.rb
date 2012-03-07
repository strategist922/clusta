require 'clusta/geometry/edge'
require 'clusta/geometry/directed/edge'
require 'clusta/geometry/neighborhood'
require 'clusta/geometry/directed/neighborhood'

module Clusta

  module Transforms

    module EdgesToNeighborhoods

      class Mapper < Wukong::Streamer::StructStreamer

        def process edge, *record
          emit edge
          emit edge.reversed unless edge.directed?
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :neighbors, :directed
        
        include Wukong::Streamer::StructRecordizer

        alias_method :vertex_label, :key
        
        def get_key new_edge, *record
          new_edge.source_label
        end

        def start! new_edge, *record
          self.neighbors   = []
          self.directed = new_edge.directed?
        end

        def accumulate new_edge, *record
          self.neighbors << new_edge.neighbor
        end

        def finalize &block
          if directed
            emit Geometry::DirectedNeighborhood.new(vertex_label, *neighbors)
          else
            emit Geometry::Neighborhood.new(vertex_label, *neighbors)
          end
        end
        
      end
      
    end
  end
  
end
