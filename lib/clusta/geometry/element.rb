module Clusta
  module Geometry

    class Element
      
      attr_accessor :input_fields

      @fields = []
      class << self ; attr_reader :fields ; end

      def self.inherited(subclass)
        subclass.instance_variable_set("@fields", @fields.dup)
        super
      end

      def self.field_names
        @fields.map { |field| field[:name].to_s }
      end

      def self.has_optional_field?
        @fields.any? { |field| field[:optional] }
      end

      def self.optional_field
        @fields.detect { |field| field[:optional] }
      end

      def self.from_string string
        return string unless string.is_a?(String)
        args  = string.split(';')
        klass_name = args.shift
        raise ArgumentError.new("Elements instantiated from a string must match the format 'klass;[field1;[field2;]...]'") unless klass_name
        Wukong.class_from_resource(klass_name).new(*args)
      end
      
      def self.field name, options={}
        raise AmbiguousArgumentsError.new("Cannot define a second optional field #{name} because field #{optional_field[:name]} is already optional.") if has_optional_field?
        attr_reader name
        case options[:type]
        when :int
          define_method "#{name}=" do |val|
            instance_variable_set("@#{name}", val.to_i)
          end
        when :float
          define_method "#{name}=" do |val|
            instance_variable_set("@#{name}", val.to_f)
          end
        when :geometry
          define_method "#{name}=" do |val|
            instance_variable_set("@#{name}", self.class.from_string(val))
          end
        else
          define_method "#{name}=" do |val|
            instance_variable_set("@#{name}", val)
          end
        end
        @fields << options.merge(:name => name)
      end

      def fields
        self.class.fields
      end

      def self.input_fields name
        alias_method name, :input_fields
      end

      def self.stream_name
        if defined?(Settings) && Settings[:full_class_names]
          to_s
        else
          to_s.split("::").last
        end
      end

      def stream_name
        self.class.stream_name
      end

      def initialize *args
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
        self.set_input_fields(*(args[self.class.fields.size..-1] || []))
      end

      def set_input_fields *input_fields
        self.input_fields = input_fields.map do |field|
          if field =~ /^[A-Z].*;/
            self.class.from_string(field)
          else
            field
          end
        end
      end

      def output_fields
        input_fields.map(&:to_s)
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
      
    end

  end
end

