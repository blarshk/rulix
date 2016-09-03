module Rulix
  class Validation < SimpleDelegator
    def valid?
      deep_compact.empty?
    end

    def error_messages
      extract_error_messages self
    end

    def extract_error_messages hash
      hash.map do |key, val|
        if data_remaining?(val)
          extract_error_messages val
        else
          format_val(key, val)
        end
      end.flatten
    end

    def data_remaining? val
      # If val is a hash and any of its children are hashes,
      # or all of them are arrays
      # we assume that we haven't yet reached the deepest point
      # of the result set
      val.is_a?(Hash) &&
        (
          val.values.any? { |v| v.is_a?(Hash)} ||
          val.values.all? { |v| v.is_a?(Array)}
        )
    end

    def format_val key, val
      if val.is_a?(Array) && val.all? { |v| v.is_a?(String) }
        val.map do |v|
          "#{key.to_s.capitalize} #{v}"
        end
      else
        val
      end
    end
  end
end