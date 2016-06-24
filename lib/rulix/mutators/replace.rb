module Rulix
  module Mutators
    class Replace
      attr_accessor :args

      def initialize args
        self.args = args
      end

      def to_proc
        method(:call)
      end

      def call string
        raise ArgumentError, "argument is not a string" unless string.is_a? String
        
        string.gsub *args
      end
    end
  end
end

Rulix::Mutator.register :replace, Rulix::Mutators::Replace