module Clusta

  module Transforms

    module EdgesToVertexArrows

      class Mapper < Wukong::Streamer::StructStreamer

        def process edge, *record
          emit edge
          emit edge.reversed unless edge.directed?
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :arrows
        
        include Wukong::Streamer::StructRecordizer

        alias_method :vertex_label, :key
        
        def get_key new_edge, *record
          new_edge.source_label
        end

        def start! new_edge, *record
          self.arrows  = []
        end

        def accumulate new_edge, *record
          self.arrows << new_edge.arrow
        end

        def finalize &block
          emit Geometry::VertexArrows.new(vertex_label, *arrows)
        end
        
      end
      
    end
  end
  
end
