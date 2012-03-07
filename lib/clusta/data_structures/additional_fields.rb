module Clusta
  module DataStructures

    module AdditionalFields

      attr_accessor :input_fields

      def set_input_fields *input_fields
        self.input_fields = input_fields.map do |field|
          if field =~ /^[A-Z].*;/
            self.class.from_string(field)
          else
            field
          end
        end
      end

      def output_fields
        input_fields.map(&:to_s)
      end
      
      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def input_fields name
          alias_method name, :input_fields
        end
      end
    end
    
  end
end
