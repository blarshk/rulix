module Rulix
  module Mutators
    class Truncate
      attr_accessor :length

      def initialize length
        self.length = length
      end

      def to_proc
        method(:call)
      end

      def call string
        raise ArgumentError, "argument is not a string" unless string.is_a? String
        
        string.slice(0, length)
      end
    end
  end
end

Rulix::Mutator.register :truncate, Rulix::Mutators::Truncate