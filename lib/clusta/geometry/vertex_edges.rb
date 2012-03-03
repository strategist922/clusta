module Clusta
  module Geometry
    
    class VertexEdges < Element

      def self.from_label_and_edges source_label, *edges
        new(source_label, *edges.map(&:target_label))
      end

      field        :source_label
      input_fields :target_labels

      def directed?
        false
      end

      def joins? target_label
        target_labels.include?(target_label)
      end

      def degree
        target_labels.size
      end
      
    end
    
  end
end
