module Rulix
  class Base
    include Rulix::Registry
    
    def self.run dataset, ruleset
      return to_enum(__callee__) unless block_given?

      dataset.deep_merge ruleset do |key, val1, val2|
        val2 = [val2] unless val2.is_a? Array

        ops = get_operations val2

        yield val1, ops
      end
    end
  end
end