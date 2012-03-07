module Clusta
  module DataStructures

    # Set up a class inheritable array of fields, along with setters
    # and methods to query field structure.
    module NamedFields
      
      def fields
        self.class.fields
      end
      
      def self.included klass
        klass.extend(ClassMethods)
        class << klass ; attr_reader :fields ; end
        klass.instance_variable_set('@fields', [])
      end

      module ClassMethods
        
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
        
        def optional_field
          @fields.detect { |field| field[:optional] }
        end

        def field name, options={}
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
      end
      
    end
    
  end
end

