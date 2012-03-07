module Clusta
  module Geometry

    class Element
      
      include Clusta::Schema
      include Clusta::Serialization
      include Clusta::Serialization::TSV

      def initialize *args
        process_args(*args)
      end

      def self.inherited subclass
        Clusta::Geometry.register_element(subclass)
        super
      end
      
    end
      
  end
end

