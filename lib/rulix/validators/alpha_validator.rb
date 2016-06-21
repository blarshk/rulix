module Rulix
  module Validators
    class AlphaValidator
      def self.to_proc
        new.method(:call)
      end

      def call string
        /^[a-zA-Z\s?]*$/ === string || [false, error_message(string)]
      end

      def error_message string
        "contains non-alpha characters"
      end
    end
  end
end

Rulix::Validator.register :alpha, Rulix::Validators::AlphaValidator