module Rulix
  module Validators
    class NumberValidator
      def self.to_proc
        new.method(:call)
      end

      def call value
        return [false, error_message] unless value

        case value
        when Integer, Float, Bignum, Fixnum
          true
        when String
          /\A[+-]?\d+\.?\d+?\Z/ === value || [false, error_message]
        else
          [false, error_message]
        end
      end

      def error_message
        "is not a number"
      end
    end
  end
end

Rulix::Validator.register :number, Rulix::Validators::NumberValidator