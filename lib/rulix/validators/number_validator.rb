module Rulix
  module Validators
    class NumberValidator
      def self.to_proc
        new.method(:call)
      end

      def call value
        case value
        when Integer, Fixnum
          true
        when String
          /^[\d]*$/ === value || [false, error_message(value)]
        else
          [false, error_message(value)]
        end
      end

      def error_message value
        "is not a number"
      end
    end
  end
end

Rulix::Validator.register :number, Rulix::Validators::NumberValidator