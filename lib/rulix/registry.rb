module Rulix
  module Registry
    def self.included other
      other.class_eval do
        @registry ||= {}

        def self.register symbol, procable = nil, &block
          return register_block symbol, &block if block_given?

          if !procable.respond_to?(:to_proc)
            unless (procable.respond_to?(:new) && procable.new.respond_to?(:to_proc))
              raise ArgumentError, "You attempted to register :#{symbol}, but the argument you passed can't be coerced into a proc!"
            end
          end

          @registry[symbol] = procable
        end

        private

        def self.register_block symbol, &block
          @registry[symbol] = block.to_proc
        end

        def self.get_operations operations
          operations.map do |op|
            get_operation op
          end
        end

        def self.get_operation operation
          case operation
          when Symbol
            registered_op = @registry[operation]

            if registered_op
              return registered_op.to_proc if registered_op.respond_to?(:to_proc)

              registered_op.new.to_proc
            else
              operation.to_proc
            end
          when Hash
            # If you're passing a hash as a rule argument, we assume that it's been registered
            # The registered rule must be instantiatable, and we assume the args passed
            # should be passed to the object as config options
            key = operation.keys.first
            arguments = operation[key]

            registered_procable = @registry[key]

            raise ArgumentError, "You've supplied a hash argument for a rule, but there's no rule registered for #{key}!" unless registered_procable

            case registered_procable
            when Proc
              registered_procable.curry[arguments ]
            else
              registered_procable.new(arguments).to_proc
            end
          when Proc
            operation
          else
            raise ArgumentError, "Can't coerce #{operation} into useable proc!" unless operation.respond_to? :to_proc

            operation.to_proc
          end
        end
      end
    end
  end
end