module Clusta
  module Geometry

    class Arrow < Element
      field :target_label
      field :weight, :optional => true

      def directed?
        false
      end
      
    end
    
  end
end

