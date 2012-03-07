require 'json'

module Clusta
  module Serialization
    module JSON

      def to_json
        {}.tap do |json|
          fields.each do |field|
            value  = send(field[:name])
            json[field[:name]] = value.to_json unless value.nil? && field[:optional]
          end
        end.to_json
      end

      def to_flat
        [stream_name, to_json]
      end

      def process_args json, *extra_inputs
        self.class.fields.each do |field|
          name = field[:name].to_s
          case
          when field[:optional]
            self.send("#{name}=", json[name]) if json.has_key?(name)
          when (!json.has_key?(name))
            raise ArgumentError.new("A #{self.class} requires a non-nil value for #{name}.")
          when field[:type] == :geometry
            self.send("#{name}=", json[name])
          else
            self.send("#{name}=", json[name])
          end
        end
        self.extra_inputs = extra_inputs
      end
      
    end
  end
end
