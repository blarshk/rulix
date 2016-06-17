module Rulix
  module Validators
    class LengthValidator
      attr_accessor :min, :max

      def initialize options = nil
        options ||= {}
        min = options[:min] || options[:exactly] || 0
        max = options[:max] || options[:exactly] || min + 1

        self.min = min
        self.max = max
      end

      def call string
        (min..max).cover?(string.length) || [false, error_message(string)]
      end

      def error_message string
        if string.length < min
          "is too short"
        elsif string.length > max
          "is too long"
        end
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :length, Rulix::Validators::LengthValidator