module Clusta
  module Geometry
    
    class DirectedDegree < Element

      field :vertex_label
      field :in_degree,   :type => :int
      field :out_degree,  :type => :int
      
      def directed?
        true
      end

      def zero
        self.class.new(vertex_label, 0, 0)
      end

      def one inbound=1, outbound=0
        self.class.new(vertex_label, inbound, outbound)
      end
      
      def +(other)
        raise DirectednessMismatchError.new unless other.directed?
        self.class.new(vertex_label, self.in_degree + other.in_degree, self.out_degree + other.out_degree)
      end
    end
    
  end
end
