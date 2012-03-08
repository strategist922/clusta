module Clusta
  module Geometry

    class Element
      
      include Clusta::Schema
      include Clusta::Serialization

      if defined?(Settings) && Settings[:serialize] == 'json'
        include Clusta::Serialization::JSON
      else
        include Clusta::Serialization::TSV
      end

      def self.inherited subclass
        Clusta::Geometry.register_element(subclass)
        super
      end
      
    end
      
  end
end

