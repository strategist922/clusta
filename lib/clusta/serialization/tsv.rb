module Clusta
  module Serialization
    module TSV

      def to_flat
        [stream_name].tap do |record|
          fields.each do |field|
            value  = send(field[:name])
            record << value.to_s unless value.nil? && field[:optional]
          end
          record.concat(extra_outputs)
        end
      end

      def suffix index
        case index.to_s
        when /1$/ then 'st'
        when /2$/ then 'nd'
        when /3$/ then 'rd'
        else 'th'
        end
      end
      
      def process_args *args
        self.class.fields.each_with_index do |field, index|
          case
          when field[:optional]
            self.send("#{field[:name]}=", args[index]) if args[index]
          when args[index].nil?
            raise ArgumentError.new("A #{self.class} requires a non-nil value for #{field[:name]} as its #{index}#{suffix(index)} argument.")
          when field[:type] == :geometry
            self.send("#{field[:name]}=", self.class.from_tsv_component_string(args[index]))
          else
            self.send("#{field[:name]}=", args[index])
          end
        end
        self.extra_inputs = (args[self.class.fields.size..-1] || [])
      end

      def extra_inputs= inputs
        @extra_inputs = inputs.map do |input|
          if input =~ /^[A-Z].*;/
            self.class.from_string(input)
          else
            input
          end
        end
      end

      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        
        def from_tsv_component_string string
          return string unless string.is_a?(String)
          args  = string.split(';')
          klass_name = args.shift
          raise ArgumentError.new("Elements instantiated from a TSV component string must match the format 'klass;[field1;[field2;]...]'") unless klass_name
          Wukong.class_from_resource(klass_name).new(*args).first
        end
      end
    end
  end
end
