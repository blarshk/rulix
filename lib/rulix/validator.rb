module Rulix
  class Validator
    include Rulix::Registry

    def self.run dataset, ruleset
      dataset = data_for_ruleset dataset, ruleset

      dataset.deep_merge ruleset do |key, val1, val2|
        val2 = [val2] unless val2.is_a? Array

        ops = get_operations val2

        success, errors = ops.reduce([true, []]) do |result, op|
          success, errors = result

          new_success, *new_errors = op.call(val1)

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

    private

    def self.data_for_ruleset dataset, ruleset
      seed = {}

      reduce_into_hash seed, dataset, ruleset
    end

    def self.reduce_into_hash hash, dataset, ruleset
      ruleset.reduce(hash) do |data_hash, values|
        key, val = values

        if val.is_a? Hash
          seed = {}
          nested_value = value_from_dataset dataset, key

          data_hash[key] = reduce_into_hash seed, nested_value, val
        else
          data_hash[key] = value_from_dataset dataset, key
        end

        data_hash
      end
    end

    def self.value_from_dataset dataset, key
      if dataset.respond_to? :[]
        dataset[key]
      else
        dataset.public_send(key)
      end
    end
  end
end