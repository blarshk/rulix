module Rulix
  module Validators
    class EmailValidator
      def self.to_proc
        new.method(:call)
      end

      def call string
        /.*@.*/ === string || [false, error_message(string)]
      end

      def error_message string
        "is not an email address"
      end
    end
  end
end

Rulix::Validator.register :email, Rulix::Validators::EmailValidator