module Clusta
  module Geometry

    class DegreePair < Element
      key   :source_label
      key   :target_label
      field :source_degree_value, :type => :int
      field :target_degree_value, :type => :int

      def directed?
        false
      end

      def assortativity
        Assortativity.new(source_degree_value, target_degree_value, 1)
      end

    end
    
  end
end
