module Rulix
  module Mutators
    class Strip
      attr_accessor :pattern

      def initialize pattern = nil
        self.pattern = pattern
      end

      def to_proc
        method(:call)
      end

      def call string
        raise ArgumentError, "argument is not a string" unless string.is_a? String
        
        if pattern
          string.gsub pattern, ''
        else
          # Just in case someone actually meant the string method :strip
          # If they didn't provide any other arguments, we can assume this
          string.strip
        end
      end
    end
  end
end

Rulix::Mutator.register :strip, Rulix::Mutators::Strip