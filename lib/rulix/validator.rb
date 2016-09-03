module Rulix
  class Validator < Rulix::Base
    include Rulix::Registry

    class << self
      def run dataset, ruleset
        result = super dataset, ruleset do |value, operations|
          begin
            success, errors = operations.reduce([true, []]) do |result, op|
              success, errors = result

              new_success, *new_errors = op.call(value)

              [success && new_success, errors.concat(new_errors)]
            end
          rescue AllowableNil
            errors = []
          end

          errors
        end

        Rulix::Validation.new(result.deep_compact)
      end

      def valid? dataset, ruleset
        run = run dataset, ruleset

        run.empty?
      end
    end
  end
end