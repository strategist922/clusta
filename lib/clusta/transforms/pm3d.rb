module Clusta

  module Transforms

    module Pm3d

      class Mapper < Wukong::Streamer::Base

        def process *record
          if record.first && record.first =~ /[^\d]/
            emit record[1..-1]
          else
            emit record
          end
        end
      end

      class Reducer < Wukong::Streamer::AccumulatingReducer

        attr_accessor :records

        def start! *record
          self.records = []
        end

        def accumulate *record
          self.records << record
        end

        def finalize &block
          records.each { |record| emit(record) }
          emit []
        end
        
      end

      class Script < Wukong::Script
        def local_mode_sort_commandline
          "sort -n -k1 -k2"
        end
      end
      
    end
  end
  
end
