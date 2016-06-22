module Rulix
  module Validators
    class NotOneOfValidator
      attr_accessor :options

      def initialize options = nil
        options ||= []
        self.options = options
      end

      def call value
        !options.include?(value) || [false, "cannot be one of #{options}"]
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :not_one_of, Rulix::Validators::NotOneOfValidator