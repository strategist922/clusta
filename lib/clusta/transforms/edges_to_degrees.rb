require 'clusta/geometry/edge'
require 'clusta/geometry/directed/edge'
require 'clusta/geometry/degree'
require 'clusta/geometry/directed/degree'

module Clusta

  module Transforms

    module EdgesToDegrees

      class Mapper < Wukong::Streamer::StructStreamer

        def process edge, *record
          edge.degrees.each { |degree| emit(degree) }
        end
        
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :degree
        
        include Wukong::Streamer::StructRecordizer
        
        def get_key new_degree, *record
          new_degree.vertex_label
        end

        def start! new_degree, *record
          self.degree = (new_degree.directed? ? new_degree.class.new(key, 0, 0) : new_degree.class.new(key, 0))
        end

        def accumulate new_degree, *record
          self.degree += new_degree
        end

        def finalize &block
          emit degree
        end
        
      end
      
    end
  end
  
end
