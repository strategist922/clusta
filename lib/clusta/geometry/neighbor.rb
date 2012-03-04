module Clusta
  module Geometry

    class Neighbor < Element
      field :label
      field :weight, :optional => true

      def directed?
        false
      end
      
    end
    
  end
end
