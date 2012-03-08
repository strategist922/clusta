require 'json'

module Clusta
  module Serialization
    module JSON

      def to_hash
        {}.tap do |json|
          fields.each do |field|
            value = send(field[:name])
            value = value.to_hash if value.respond_to?(:to_hash)
            json[field[:name]] = value
          end
        end
      end

      def to_flat
        [stream_name].tap do |record|
          keys.each do |key|
            record << self.send(key[:name])
          end
          data = non_key_field_data
          record << data.to_json unless data.empty?
          record.concat(extra_outputs)
        end
      end

      def non_key_field_data
        {}.tap do |data|
          non_key_fields.each do |field|
            value = send(field[:name])
            value = value.to_hash if value.respond_to?(:to_hash)
            data[field[:name]] = value unless value.nil? && field[:optional]
          end
        end
      end

      def process_args *args
        json_index = 0
        self.class.keys.each_with_index do |key, index|
          self.send("#{key[:name]}=", args[index])
          json_index = index + 1
        end

        if args[json_index]
          if args[json_index].is_a?(Hash)
            data = args[json_index]
          else
            data = ::JSON.parse(args[json_index])
          end
        else
          data = {}
        end

        non_key_fields.each do |field|
          name = field[:name].to_s
          case 
          when field[:optional]
            self.send("#{name}=", data[name]) if data.has_key?(name)
          when (!data.has_key?(name))
            raise ArgumentError.new("A #{self.class} requires a non-nil value for #{name}.")
          when field[:type] == :geometry
            self.send("#{name}=", data[name])
          else
            self.send("#{name}=", data[name])
          end
        end
        
        self.extra_inputs = (args[(json_index + 1)..-1] || [])
      end

      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        
        def from_json_component data
          
        end
        
      end
      
    end
  end
end
