require 'clusta/serialization/tsv'

module Clusta

  # Defines methods that allow a class to (de)serialize itself in a
  # way compatabile with Wukong.
  module Serialization

    def self.included klass
      klass.extend(ClassMethods)
    end

    def stream_name
      self.class.stream_name
    end

    module ClassMethods

      def set_stream_name string
        Geometry.register_element self, string
        @stream_name = string
      end

      def abbreviate string
        Geometry.register_element self, string
        @abbreviation = string
      end

      def abbreviation
        @abbreviation
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
        when defined?(Settings) && Settings[:class_names].to_s == 'short' && abbreviation
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
