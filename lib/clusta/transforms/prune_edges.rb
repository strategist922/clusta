require 'clusta/geometry/edge'
require 'clusta/geometry/directed/edge'

Settings.define :min_weight,            :type => Float,    :description => "Prune edges with weight less than this weight."
Settings.define :max_weight,            :type => Float,    :description => "Prune edges with weight more than this weight."

module Clusta

  module Transforms

    module PruneEdges

      class Mapper < Wukong::Streamer::StructStreamer

        def before_stream
          raise ArgumentError.new("Must specify either a min_weight or a max_weight") if Settings[:min_weight].nil? && Settings[:max_weight].nil?
        end

        def within_weight_range? edge
          return false if Settings[:min_weight] && Settings[:min_weight] > edge.weight.to_f
          return false if Settings[:max_weight] && Settings[:max_weight] < edge.weight.to_f
          true
        end
        
        def process edge, *record
          emit(edge) if edge.weighted? && within_weight_range?(edge)
        end
        
      end
      
    end
  end
  
end
