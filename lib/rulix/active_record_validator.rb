module Rulix
  class ActiveRecordValidator
    attr_accessor :ruleset

    def initialize *args
      ruleset = args.first[:ruleset]

      self.ruleset = ruleset
    end

    def validate record
      if Rulix::Validator.valid? record, ruleset
        true
      else
        errors = Rulix::Validator.errors record, ruleset

        reduce_errors_into record, errors

        false
      end
    end

    def reduce_errors_into record, error_hash
      error_hash.reduce(record) do |subject, error|
        key, val = error

        if val.is_a? Hash
          reduce_errors_into record.send(key), val
        else
          val.flatten.map do |err|
            subject.errors.add key, err
          end
        end

        subject
      end
    end
  end
end