module Clusta

  module Geometry

    class Assortativity < Element

      key   :source_degree_value, :type => :int
      key   :target_degree_value, :type => :int
      field :count,               :type => :int

      def directed?
        false
      end

      def key
        [source_degree_value, target_degree_value]
      end

      def zero
        self.class.new(*(key + [0]))
      end

      def +(other)
        raise DirectednessMismatchError.new if other.directed?
        self.class.new(*(key + [count + other.count]))
      end
      
    end
    
  end
end
