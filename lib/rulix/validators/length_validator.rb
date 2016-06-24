module Rulix
  module Validators
    class LengthValidator
      attr_accessor :min, :max, :exactly

      def initialize options = nil
        options ||= {}
        min = options[:min] || 0
        max = options[:max]

        self.exactly = options[:exactly]
        self.min = min
        self.max = max
      end

      def call string
        return [false, "can't be nil"] unless string

        if exactly.nil?
          if min && max
            (min..max).cover?(string.length) || [false, error_message(string)]
          elsif min && !max
            string.length >= min || [false, error_message(string)]
          elsif max && !min
            string.length <= max || [false, error_message(string)]
          end
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