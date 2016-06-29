# Stole this from Rails; rather copy the source than introduce
# ActiveSupport as a dependency
class Hash
  # Returns a new hash with +self+ and +other_hash+ merged recursively.
  #
  #   h1 = { a: true, b: { c: [1, 2, 3] } }
  #   h2 = { a: false, b: { x: [3, 4, 5] } }
  #
  #   h1.deep_merge(h2) # => { a: false, b: { c: [1, 2, 3], x: [3, 4, 5] } }
  #
  # Like with Hash#merge in the standard library, a block can be provided
  # to merge values:
  #
  #   h1 = { a: 100, b: 200, c: { c1: 100 } }
  #   h2 = { b: 250, c: { c1: 200 } }
  #   h1.deep_merge(h2) { |key, this_val, other_val| this_val + other_val }
  #   # => { a: 100, b: 450, c: { c1: 300 } }
  def deep_merge(other_hash, &block)
    dup.deep_merge!(other_hash, &block)
  end

  # Same as +deep_merge+, but modifies +self+.
  def deep_merge!(other_hash, &block)
    other_hash.each_pair do |current_key, other_value|
      this_value = self[current_key]

      self[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
        this_value.deep_merge(other_value, &block)
      else
        if block_given? && key?(current_key)
          block.call(current_key, this_value, other_value)
        else
          other_value
        end
      end
    end

    self
  end

  # Returns a hash, removing all values that cause the block to evaluate to true
  # Iterates recursively over nested hashes
  def deep_reject &block
    dup.deep_reject! &block
  end

  # Same as +deep_reject+, but modifies +self+.
  def deep_reject! &block
    each_pair do |current_key, value|
      this_value = self[current_key]

      if this_value.is_a?(Hash)
        self[current_key] = this_value.deep_reject &block
      else
        if block_given? && key?(current_key)
          self.delete current_key if block.call current_key, this_value
        end
      end
    end
  end

  # Returns a hash, removing all elements that
  # respond to and return true from :empty?
  # Iterates recursively over nested hashes
  # Will continue to call itself until the second run
  # does not differ from the first (kind of gross)
  # TODO: Try to make this less gross
  def deep_compact
    result = dup.deep_compact!
    result2 = result.dup.deep_compact!

    if result != result2
      result = result2

      result.deep_compact
    end

    result
  end

  def deep_compact!
    each_pair do |current_key, value|
      this_value = self[current_key]

      if this_value.respond_to?(:empty?)
        if this_value.empty?
          self.delete current_key
        elsif this_value.is_a?(Hash)          
          self[current_key] = this_value.deep_compact
        elsif this_value.is_a?(Array)
          if this_value.all? { |v| v.respond_to?(:empty?) && v.empty? }
            self.delete current_key
          elsif this_value.all? { |v| v.respond_to?(:deep_compact) }
            self[current_key] = this_value.map(&:deep_compact)
          end
        end
      else
        self.delete current_key if this_value.nil?
      end
    end
  end
end