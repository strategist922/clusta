require 'clusta/data_structures/named_fields'
require 'clusta/data_structures/additional_fields'
require 'clusta/data_structures/serialization'

module Clusta
  module Geometry

    class Element
      include Clusta::DataStructures::NamedFields
      include Clusta::DataStructures::AdditionalFields
      include Clusta::DataStructures::Serialization

      def initialize *args
        set_input_fields(*process_args(*args))
      end

      def self.inherited subclass
        Clusta::Geometry.register_element(subclass)
        super
      end
      
    end
      
  end
end

