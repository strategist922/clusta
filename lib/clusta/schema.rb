module Clusta
  module Schema

    def extra_inputs
      @extra_inputs ||= []
    end
    attr_writer :extra_inputs
    
    def extra_outputs
      extra_inputs.map(&:to_s)
    end

    def fields
      self.class.fields
    end

    def keys
      self.class.keys
    end

    def non_key_fields
      self.class.non_key_fields
    end
    
    def self.included klass
      klass.extend(ClassMethods)
      class << klass ; attr_reader :fields ; end
      klass.instance_variable_set('@fields', [])
    end

    module ClassMethods

      def extra_inputs name
        alias_method name, :extra_inputs
      end
      
      def inherited(subclass)
        subclass.instance_variable_set("@fields", @fields.dup)
        super
      end
      
      def field_names
        @fields.map { |field| field[:name].to_s }
      end
      
      def has_optional_field?
        @fields.any? { |field| field[:optional] }
      end

      def has_non_key_field?
        @fields.any? { |field| ! field[:key] }
      end
      
      def optional_field
        @fields.detect { |field| field[:optional] }
      end

      def keys
        @fields.find_all { |field| field[:key] }
      end

      def non_key_fields
        @fields.find_all { |field| ! field[:key] }
      end
      
      def field name, options={}
        raise AmbiguousArgumentsError.new("Cannot define a second optional field #{name} because field #{optional_field[:name]} is already optional.") if has_optional_field?
        
        raise SortError.new("The first field defined must be a key that can be sorted on.")                             if @fields.empty? && (!options[:key])
        raise SortError.new("Cannot define a key field #{name} because some non-key fields have already been defined.") if options[:key] && has_non_key_field?
        raise SortError.new("Key fields (#{name}) cannot have type :geometry")                                          if options[:key] && options[:type] == :geometry
        
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
        else
          define_method "#{name}=" do |val|
            instance_variable_set("@#{name}", val)
          end
        end
        @fields << options.merge(:name => name)
      end

      def key name, options={}
        field name, options.merge(:key => true)
      end
      
    end
    
  end
end

