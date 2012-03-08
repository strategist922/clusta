Settings.define :as, :required => true, :description => "Name of the Clusta class to import data as."

module Clusta

  module Transforms

    module Import

      def self.help
        "Import data into the format expected by Clusta."
      end

      class Mapper < Wukong::Streamer::Base

        def process *record
          emit record.unshift(Settings[:as])
        end
      end
      
    end
  end
  
end
