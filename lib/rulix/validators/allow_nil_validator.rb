require 'date'

module Rulix
  module Validators
    class AllowNilValidator
      def self.to_proc
        new.method(:call)
      end

      def call val
        if val.nil?
          raise AllowableNil
        else
          true
        end
      end
    end
  end
end

Rulix::Validator.register :allow_nil, Rulix::Validators::AllowNilValidator