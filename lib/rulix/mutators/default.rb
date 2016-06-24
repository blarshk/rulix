module Rulix
  module Mutators
    class Default
      attr_accessor :default_val

      def initialize default_val
        self.default_val = default_val
      end

      def to_proc
        method(:call)
      end

      def call string
        if string
          string
        else
          default_val
        end
      end
    end
  end
end

Rulix::Mutator.register :default, Rulix::Mutators::Default