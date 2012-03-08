module Clusta
  module Geometry

    class Neighbor < Element
      
      key   :label
      field :weight, :optional => true

      def directed?
        false
      end
      
    end
    
  end
end
