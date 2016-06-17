module Rulix
  module Validators
    class FormatValidator
      attr_accessor :pattern, :message

      def initialize options = nil
        options ||= {}

        self.pattern = options[:pattern]
        self.message = options.fetch :message, 'does not match format'
      end

      def call string
        pattern === string || [false, message]
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :format, Rulix::Validators::FormatValidator