module Clusta

  module Transforms

    module VertexArrowsToEdgeDegreePairs

      class Mapper < Wukong::Streamer::StructStreamer

        def process vertex_arrows, *record
          vertex_arrows.reversed_edge_degree_pairs.each { |edge_degree| emit(edge_degree) }
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :edge_degree_pairs, :source_degree, :source_in_degree, :source_out_degree
        
        include Wukong::Streamer::StructRecordizer

        def get_key new_edge_degree_pair, *record
          new_edge_degree_pair.source_label
        end

        def start! new_edge_degree_pair, *record
          self.edge_degree_pairs = []
          if new_edge_degree_pair.directed?
            self.source_in_degree  = 0
            self.source_out_degree = 0
          else
            self.source_degree = 0
          end
        end

        def accumulate new_edge_degree_pair, *record
          self.edge_degree_pairs      << new_edge_degree_pair
          if new_edge_degree_pair.directed?
            self.source_in_degree  += new_edge_degree_pair.source_in_degree_value
            self.source_out_degree += new_edge_degree_pair.source_out_degree_value
          else
            self.source_degree += new_edge_degree_pair.source_degree_value
          end
        end

        def finalize &block
          edge_degree_pairs.each do |edge_degree_pair|
            if edge_degree_pair.directed?
              edge_degree_pair.source_in_degree_value  = source_in_degree
              edge_degree_pair.source_out_degree_value = source_out_degree
            else
              edge_degree_pair.source_degree_value = source_degree
            end
            emit edge_degree_pair
          end
        end
        
      end
      
    end
  end
  
end

