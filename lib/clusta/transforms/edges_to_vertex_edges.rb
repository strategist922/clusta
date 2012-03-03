module Clusta

  module Transforms

    module EdgesToVertexEdges

      class Mapper < Wukong::Streamer::StructStreamer

        def process edge, *record
          emit edge
          emit edge.reversed
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :edges
        
        include Wukong::Streamer::StructRecordizer

        alias_method :vertex_label, :key
        
        def get_key new_edge, *record
          new_edge.source_label
        end

        def start! new_edge, *record
          self.edges  = [new_edge]
        end

        def accumulate new_edge, *record
          self.edges << new_edge
        end

        def finalize &block
          emit Geometry::VertexEdges.from_label_and_edges(vertex_label, *edges)
        end
        
      end
      
    end
  end
  
end
