module Rulix
  class Mutator < Rulix::Base
    include Rulix::Registry

    def self.run dataset, ruleset
      super dataset, ruleset do |value, operations|
        if value.is_a? Array
          value.map { |val| operations.reduce(val) { |v, op| op.call(v) } }
        else
          operations.reduce(value) { |val, op| op.call(val) }
        end
      end
    end

    def self.reduce_into_hash hash, dataset, ruleset
      # Migrate over any keys the ruleset has that the dataset doesn't
      # so we can set defaults and handle cases where no data exists
      if dataset.respond_to? :keys
        key_diff = ruleset.keys - dataset.keys

        key_diff.each do |key|
          hash[key] = nil
        end
      end

      new_ruleset = ruleset.reduce(hash) do |data_hash, values|
        key, rule_val = values

        nested_value = value_from_dataset dataset, key

        if rule_val.is_a?(Hash) && (nested_value.is_a?(Hash) || rule_val.keys.all? { |k| nested_value.respond_to?(k) })
          seed = {}

          data_hash[key] = reduce_into_hash seed, nested_value, rule_val
        else
          data_hash[key] = nested_value
        end

        data_hash
      end

      # For mutation, we need to ensure that the resulting dataset
      # contains all original, unmodified values as well as mutated values
      if dataset.is_a? Hash
        new_ruleset.deep_merge dataset
      else
        new_ruleset
      end
    end
  end
end