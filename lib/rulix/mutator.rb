require_relative './registry'

module Rulix
  class Mutator
    include Rulix::Registry

    def self.run dataset, ruleset
      dataset.deep_merge ruleset do |key, val1, val2|
        val2 = [val2] unless val2.is_a? Array

        ops = get_operations val2

        ops.reduce(val1) { |val, op| op.call(val) }
      end
    end
  end
end