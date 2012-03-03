module Clusta

  module Transforms

    module Import

      class Mapper < Wukong::Streamer::Base

        def process *record
          emit record.unshift(Settings[:class])
        end
      end
      
    end
  end
  
end
