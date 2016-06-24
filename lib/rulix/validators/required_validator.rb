module Rulix
  module Validators
    class RequiredValidator
      def call value
        return [false, 'is required'] unless value

        true
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :required, Rulix::Validators::RequiredValidator