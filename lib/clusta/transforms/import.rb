module Clusta

  module Transforms

    module Import

      class Mapper < Wukong::Streamer::Base

        def process *record
          emit record.unshift(Settings[:as])
        end
      end
      
    end
  end
  
end
