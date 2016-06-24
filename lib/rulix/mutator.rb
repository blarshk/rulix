module Rulix
  class Mutator < Rulix::Base
    include Rulix::Registry

    def self.run dataset, ruleset
      super dataset, ruleset do |value, operations|
        operations.reduce(value) { |val, op| op.call(val) }
      end
    end
  end
end