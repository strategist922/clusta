module Clusta
  module Geometry
    
    class Degree < Element

      abbreviate 'D'

      field :vertex_label
      field :degree, :type => :int
      
      def directed?
        false
      end

      def zero
        self.class.new(vertex_label, 0)
      end

      def one deg=1
        self.class.new(vertex_label, deg)
      end
      
      def +(other)
        raise DirectednessMismatchError.new if other.directed?
        self.class.new(vertex_label, self.degree + other.degree)
      end
    end
    
  end
end
