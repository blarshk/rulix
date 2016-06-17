module Rulix
  module Validators
    class RequiredValidator
      def call value
        !value.nil? || [false, 'is required']
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :required, Rulix::Validators::RequiredValidator