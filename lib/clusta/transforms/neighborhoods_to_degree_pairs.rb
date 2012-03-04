module Clusta

  module Transforms

    module NeighborhoodsToDegreePairs

      class Mapper < Wukong::Streamer::StructStreamer

        def process neighborhood, *record
          neighborhood.reversed_degree_pairs.each { |degree_pair| emit(degree_pair) }
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :degree_pairs, :source_degree, :source_in_degree, :source_out_degree
        
        include Wukong::Streamer::StructRecordizer

        def get_key new_degree_pair, *record
          new_degree_pair.source_label
        end

        def start! new_degree_pair, *record
          self.degree_pairs = []
          if new_degree_pair.directed?
            self.source_in_degree  = 0
            self.source_out_degree = 0
          else
            self.source_degree = 0
          end
        end

        def accumulate new_degree_pair, *record
          self.degree_pairs      << new_degree_pair
          if new_degree_pair.directed?
            self.source_in_degree  += new_degree_pair.source_in_degree_value
            self.source_out_degree += new_degree_pair.source_out_degree_value
          else
            self.source_degree += new_degree_pair.source_degree_value
          end
        end

        def finalize &block
          degree_pairs.each do |degree_pair|
            if degree_pair.directed?
              degree_pair.source_in_degree_value  = source_in_degree
              degree_pair.source_out_degree_value = source_out_degree
            else
              degree_pair.source_degree_value = source_degree
            end
            emit degree_pair
          end
        end
        
      end
      
    end
  end
  
end

