# Stole this from Rails; rather copy the source than introduce
# ActiveSupport as a dependency

unless Hash.instance_methods.include? :deep_merge
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
  end
end

unless Hash.instance_methods.include? :deep_symbolize_keys
  # If hash doesn't respond to :deep_symbolize_keys, we can assume
  # it needs all the key transformation methods

  class Hash
    # Returns a new hash with all keys converted using the +block+ operation.
    #
    #  hash = { name: 'Rob', age: '28' }
    #
    #  hash.transform_keys { |key| key.to_s.upcase } # => {"NAME"=>"Rob", "AGE"=>"28"}
    #
    # If you do not provide a +block+, it will return an Enumerator
    # for chaining with other methods:
    #
    #  hash.transform_keys.with_index { |k, i| [k, i].join } # => {"name0"=>"Rob", "age1"=>"28"}
    def transform_keys
      return enum_for(:transform_keys) { size } unless block_given?
      result = {}
      each_key do |key|
        result[yield(key)] = self[key]
      end
      result
    end

    # Destructively converts all keys using the +block+ operations.
    # Same as +transform_keys+ but modifies +self+.
    def transform_keys!
      return enum_for(:transform_keys!) { size } unless block_given?
      keys.each do |key|
        self[yield(key)] = delete(key)
      end
      self
    end

    # Returns a new hash with all keys converted to strings.
    #
    #   hash = { name: 'Rob', age: '28' }
    #
    #   hash.stringify_keys
    #   # => {"name"=>"Rob", "age"=>"28"}
    def stringify_keys
      transform_keys(&:to_s)
    end

    # Destructively converts all keys to strings. Same as
    # +stringify_keys+, but modifies +self+.
    def stringify_keys!
      transform_keys!(&:to_s)
    end

    # Returns a new hash with all keys converted to symbols, as long as
    # they respond to +to_sym+.
    #
    #   hash = { 'name' => 'Rob', 'age' => '28' }
    #
    #   hash.symbolize_keys
    #   # => {:name=>"Rob", :age=>"28"}
    def symbolize_keys
      transform_keys{ |key| key.to_sym rescue key }
    end
    alias_method :to_options,  :symbolize_keys

    # Destructively converts all keys to symbols, as long as they respond
    # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
    def symbolize_keys!
      transform_keys!{ |key| key.to_sym rescue key }
    end
    alias_method :to_options!, :symbolize_keys!

    # Validates all keys in a hash match <tt>*valid_keys</tt>, raising
    # +ArgumentError+ on a mismatch.
    #
    # Note that keys are treated differently than HashWithIndifferentAccess,
    # meaning that string and symbol keys will not match.
    #
    #   { name: 'Rob', years: '28' }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key: :years. Valid keys are: :name, :age"
    #   { name: 'Rob', age: '28' }.assert_valid_keys('name', 'age') # => raises "ArgumentError: Unknown key: :name. Valid keys are: 'name', 'age'"
    #   { name: 'Rob', age: '28' }.assert_valid_keys(:name, :age)   # => passes, raises nothing
    def assert_valid_keys(*valid_keys)
      valid_keys.flatten!
      each_key do |k|
        unless valid_keys.include?(k)
          raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{valid_keys.map(&:inspect).join(', ')}")
        end
      end
    end

    # Returns a new hash with all keys converted by the block operation.
    # This includes the keys from the root hash and from all
    # nested hashes and arrays.
    #
    #  hash = { person: { name: 'Rob', age: '28' } }
    #
    #  hash.deep_transform_keys{ |key| key.to_s.upcase }
    #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
    def deep_transform_keys(&block)
      _deep_transform_keys_in_object(self, &block)
    end

    # Destructively converts all keys by using the block operation.
    # This includes the keys from the root hash and from all
    # nested hashes and arrays.
    def deep_transform_keys!(&block)
      _deep_transform_keys_in_object!(self, &block)
    end

    # Returns a new hash with all keys converted to strings.
    # This includes the keys from the root hash and from all
    # nested hashes and arrays.
    #
    #   hash = { person: { name: 'Rob', age: '28' } }
    #
    #   hash.deep_stringify_keys
    #   # => {"person"=>{"name"=>"Rob", "age"=>"28"}}
    def deep_stringify_keys
      deep_transform_keys(&:to_s)
    end

    # Destructively converts all keys to strings.
    # This includes the keys from the root hash and from all
    # nested hashes and arrays.
    def deep_stringify_keys!
      deep_transform_keys!(&:to_s)
    end

    # Returns a new hash with all keys converted to symbols, as long as
    # they respond to +to_sym+. This includes the keys from the root hash
    # and from all nested hashes and arrays.
    #
    #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
    #
    #   hash.deep_symbolize_keys
    #   # => {:person=>{:name=>"Rob", :age=>"28"}}
    def deep_symbolize_keys
      deep_transform_keys{ |key| key.to_sym rescue key }
    end

    # Destructively converts all keys to symbols, as long as they respond
    # to +to_sym+. This includes the keys from the root hash and from all
    # nested hashes and arrays.
    def deep_symbolize_keys!
      deep_transform_keys!{ |key| key.to_sym rescue key }
    end

    private
      # support methods for deep transforming nested hashes and arrays
      def _deep_transform_keys_in_object(object, &block)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = _deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map {|e| _deep_transform_keys_in_object(e, &block) }
        else
          object
        end
      end

      def _deep_transform_keys_in_object!(object, &block)
        case object
        when Hash
          object.keys.each do |key|
            value = object.delete(key)
            object[yield(key)] = _deep_transform_keys_in_object!(value, &block)
          end
          object
        when Array
          object.map! {|e| _deep_transform_keys_in_object!(e, &block)}
        else
          object
        end
      end
  end
end

# Useful hash method necessary for determining if a dataset
# is valid; we remove all empty elements until just key/vals
# with non-empty error message arrays are left
class Hash
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