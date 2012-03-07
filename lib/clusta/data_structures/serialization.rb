module Clusta
  module DataStructures

    # Defines methods that allow a class to (de)serialize itself in a
    # way compatabile with Wukong.
    module Serialization

      def self.included klass
        klass.extend(ClassMethods)
      end

      def stream_name
        self.class.stream_name
      end

      def process_args *args
        self.class.fields.each_with_index do |field, index|
          suffix = case index.to_s
                   when /1$/ then 'st'
                   when /2$/ then 'nd'
                   when /3$/ then 'rd'
                   else 'th'
                   end
          case
          when field[:optional]
            self.send("#{field[:name]}=", args[index]) if args[index]
          when args[index].nil?
            raise ArgumentError.new("A #{self.class} requires a non-nil value for #{field[:name]} as its #{index}#{suffix} argument.")
          else
            self.send("#{field[:name]}=", args[index])
          end
        end
        args[self.class.fields.size..-1] || []
      end

      def to_flat
        [stream_name].tap do |record|
          fields.each do |field|
            value  = send(field[:name])
            record << value.to_s unless value.nil? && field[:optional]
          end
        end.concat(output_fields)
      end

      def to_s
        to_flat.join(';')
      end
      
      module ClassMethods

        def set_stream_name string
          @stream_name = string
        end

        def abbreviate string
          Geometry.register_element self, string
          @abbreviation = string
        end

        def abbreviation
          @abbreviation
        end
        
        def from_string string
          return string unless string.is_a?(String)
          args  = string.split(';')
          klass_name = args.shift
          raise ArgumentError.new("Elements instantiated from a string must match the format 'klass;[field1;[field2;]...]'") unless klass_name
          Wukong.class_from_resource(klass_name).new(*args)
        end

        def all_stream_names
          [stream_name].tap do |names|
            names << abbreviation if abbreviation
            names << to_s
            names << to_s.split('::').last if respond_to?(:name) && name
          end
        end

        def stream_name
          return @stream_name if @stream_name
          case
          when defined?(Settings) && Settings[:class_names].to_s == 'short'
            @stream_name = abbreviation
          when defined?(Settings) && Settings[:class_names].to_s == 'long'
            @stream_name = to_s
          else
            @stream_name = to_s.split("::").last
          end
        end
      end
    end

  end
end
