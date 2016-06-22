module Rulix
  module Validators
    class AlphaNumericValidator
      def self.to_proc
        new.method(:call)
      end

      def call string
        /^[a-zA-Z0-9\s?]*$/ === string || [false, error_message(string)]
      end

      def error_message string
        "contains non-alpha-numeric characters"
      end
    end
  end
end

Rulix::Validator.register :alphanum, Rulix::Validators::AlphaNumericValidator