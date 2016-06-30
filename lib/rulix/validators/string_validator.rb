module Rulix
  module Validators
    class StringValidator
      def self.to_proc
        new.method(:call)
      end

      def call value
        return [false, error_message] unless value

        String === value || [false, error_message]
      end

      def error_message
        "is not a string"
      end
    end
  end
end

Rulix::Validator.register :string, Rulix::Validators::StringValidator