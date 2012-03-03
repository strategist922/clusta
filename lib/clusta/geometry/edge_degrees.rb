module Clusta
  module Geometry

    class EdgeDegrees < Edge

      field :source_label
      field :target_label
      field :source_degree_value, :type => :int
      field :target_degree_value, :type => :int

      def weighted?
        false
      end

      def source_degree
        Degree.new(
      end

      def target_degree
        
      end
      
    end
    
  end
end
