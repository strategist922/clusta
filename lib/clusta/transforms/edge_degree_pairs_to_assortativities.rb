module Clusta

  module Transforms

    module EdgeDegreePairsToAssortativities

      class Mapper < Wukong::Streamer::StructStreamer

        def process edge_degree_pair, *record
          emit edge_degree_pair.assortativity
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :assortativity

        include Wukong::Streamer::StructRecordizer
        
        def get_key new_assortativity, *record
          new_assortativity.key
        end

        def start! new_assortativity, *record
          self.assortativity = new_assortativity.zero
        end

        def accumulate new_assortativity, *record
          self.assortativity += new_assortativity
        end

        def finalize &block
          emit self.assortativity
        end
        
      end
      
    end
  end
  
end
