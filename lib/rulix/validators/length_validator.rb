module Rulix
  module Validators
    class LengthValidator
      attr_accessor :min, :max, :exactly

      def initialize options = nil
        options ||= {}
        min = options[:min] || 0
        max = options[:max] || min + 1

        self.exactly = options[:exactly]
        self.min = min
        self.max = max
      end

      def call string
        if exactly.nil?
          (min..max).cover?(string.length) || [false, error_message(string)]
        else
          exactly == string.length || [false, exact_error_message]
        end
      end

      def exact_error_message
        "must be exactly #{exactly} characters long"
      end

      def error_message string
        if string.length < min
          "must be at least #{min} characters long"
        elsif string.length > max
          "cannot be longer than #{max} characters"
        end
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :length, Rulix::Validators::LengthValidator