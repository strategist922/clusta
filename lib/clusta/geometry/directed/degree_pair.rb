module Clusta
  module Geometry

    class DirectedDegreePair < Element
      
      key   :source_label
      key   :target_label
      field :source_in_degree_value,  :type => :int
      field :source_out_degree_value, :type => :int
      field :target_in_degree_value,  :type => :int
      field :target_out_degree_value, :type => :int
      field :weight,                  :optional => true

      def directed?
        true
      end

      def assortativity
        Assortativity.new(source_in_degree_value, target_out_degree_value, 1)
      end
      
    end
    
  end
end
