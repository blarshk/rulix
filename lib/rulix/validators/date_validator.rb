require 'date'

module Rulix
  module Validators
    class DateValidator
      def self.to_proc
        new.method(:call)
      end

      def call date
        if date
          begin
            Date.parse date

            true
          rescue ArgumentError
            [false, "is not a date"]
          end
        else
          [false, 'is not a date']
        end
      end

      def error_message value = nil
        "is not a date"
      end
    end
  end
end

Rulix::Validator.register :date, Rulix::Validators::DateValidator