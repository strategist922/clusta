module Clusta
  module Geometry

    class Edge < Element

      field :source_label
      field :target_label
      field :weight,      :optional => true

      def weighted?
        self.weight
      end

      def directed?
        false
      end

      def joins? label
        source_label == label || target_label == label
      end

      def labels_string
        [source_label, target_label].map(&:to_s).join(' -> ')
      end

      def source_degree
        Degree.new(source_label, 1)
      end

      def target_degree
        Degree.new(target_label, 1)
      end

      def degrees
        [source_degree, target_degree]
      end

      def degree_of label
        case label
        when source_label then source_degree
        when target_label then target_degree
        else
          raise Error.new("This edge (#{labels_string}) does not contain vertex #{label}")
        end
      end

      def reversed
        if weighted?
          self.class.new(target_label, source_label, weight)
        else
          self.class.new(target_label, source_label)
        end
      end
      
    end
    
  end
end
