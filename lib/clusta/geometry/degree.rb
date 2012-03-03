module Clusta
  module Geometry
    
    class Degree < Element

      field :vertex_label
      field :degree, :type => :int
      
      def directed?
        false
      end

      def +(other)
        raise DirectednessMismatchError.new if other.directed?
        self.class.new(vertex_label, self.degree + other.degree)
      end
    end
    
  end
end
