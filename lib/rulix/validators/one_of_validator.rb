module Rulix
  module Validators
    class OneOfValidator
      attr_accessor :options

      def initialize options = nil
        options ||= []
        self.options = options
      end

      def call value
        (value && options.include?(value)) || [false, "is not one of #{options}"]
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :one_of, Rulix::Validators::OneOfValidator