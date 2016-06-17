module Rulix
  module Validators
    class FormatValidator
      attr_accessor :format, :message

      def initialize options = nil
        options ||= {}

        self.format = options[:format]
        self.message = options.fetch :message, 'does not match format'
      end

      def call string
        format === string || [false, message]
      end

      def to_proc
        method(:call)
      end
    end
  end
end

Rulix::Validator.register :format, Rulix::Validators::FormatValidator