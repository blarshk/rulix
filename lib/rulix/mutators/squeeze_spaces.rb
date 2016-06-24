module Rulix
  module Mutators
    class SqueezeSpaces
      def self.to_proc
        new.method(:call)
      end

      def call string
        raise ArgumentError, "argument is not a string" unless string.is_a? String
        
        string.squeeze ' '
      end
    end
  end
end

Rulix::Mutator.register :squeeze_spaces, Rulix::Mutators::SqueezeSpaces