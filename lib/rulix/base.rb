module Rulix
  class Base
    include Rulix::Registry

    def self.run dataset, ruleset
      return to_enum(__callee__) unless block_given?

      dataset = data_for_ruleset dataset, ruleset

      dataset.deep_merge ruleset do |key, data_obj, operation_obj|
        if (data_obj.is_a?(Array) && data_obj.all? { |o| o.respond_to?(:deep_merge) })
          data_obj.map do |data|
            data.deep_merge operation_obj.first do |k, d, o|
              yield *handle_merge(d, o)
            end
          end
        elsif data_obj.is_a?(Array)
          data_obj.map do |obj|
            yield *handle_merge(obj, operation_obj)
          end.flatten
        else
          yield *handle_merge(data_obj, operation_obj)
        end
      end
    end

    def self.handle_merge data_obj, operation_obj
      operation_obj = [operation_obj] unless operation_obj.is_a? Array

      ops = get_operations operation_obj

      [data_obj, ops]
    end

    def self.data_for_ruleset dataset, ruleset
      seed = {}

      reduce_into_hash seed, dataset, ruleset
    end

    def self.reduce_into_hash hash, dataset, ruleset
      ruleset.reduce(hash) do |data_hash, values|
        key, rule_val = values

        nested_value = value_from_dataset dataset, key

        if rule_val.is_a?(Hash) && (nested_value.is_a?(Hash) || rule_val.keys.all? { |k| nested_value.respond_to?(k) })
          seed = {}

          data_hash[key] = reduce_into_hash seed, nested_value, rule_val
        elsif nested_value.is_a?(Array) && nested_value.all? { |val| val.is_a?(Hash) }
          seed = {}

          data_hash[key] = nested_value.map do |nested_val|
            reduce_into_hash seed, nested_val, rule_val.first
          end
        else
          data_hash[key] = nested_value
        end

        data_hash
      end
    end

    def self.value_from_dataset dataset, key
      # Not a fan of type-checking here, would rather do a :respond_to? :[]
      # However, that scenario breaks when validating sensitive data
      # on an ActiveRecord model (like password) or any other attribute
      # that is manipulated in the biz logic layer before being set on
      # the db (e.g.: Model(:ssn) -> Database(:encrypted_ssn))
      if dataset.is_a? Hash
        dataset[key]
      else
        dataset.public_send(key)
      end
    end
  end
end