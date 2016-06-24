module Rulix
  class Validator < Rulix::Base
    include Rulix::Registry

    def self.run dataset, ruleset
      super dataset, ruleset do |value, operations|
        success, errors = operations.reduce([true, []]) do |result, op|
          success, errors = result

          new_success, *new_errors = op.call(value)

          [success && new_success, errors.concat(new_errors)]
        end

        errors
      end
    end

    def self.valid? dataset, ruleset
      run = run dataset, ruleset

      run.deep_compact.empty?
    end

    def self.errors dataset, ruleset
      run = run dataset, ruleset

      run.deep_compact
    end
  end
end