require 'test_helper'

class ActiveRecordModel
  attr_accessor :ssn, :errors

  def initialize options = nil
    options ||= {}

    self.ssn = options[:ssn]
    self.errors = ActiveRecordErrors.new
  end
end

class ActiveRecordErrors
  attr_accessor :errors
  
  def initialize *args
    self.errors = {}
  end

  def add key, message
    errors[key] ||= []

    errors[key] << message
  end

  def messages
    errors
  end
end

class TestActiveRecordValidator < MiniTest::Test
  def test_validate
    rules = {
      ruleset: {
        ssn: [format: /\d{9}/]
      }
    }

    validator = Rulix::ActiveRecordValidator.new rules, ActiveRecordModel

    model = ActiveRecordModel.new ssn: '123-12-1234'

    result = validator.validate model
    expected_result = { ssn: ['does not match format'] }

    assert_equal expected_result, result.errors.messages
  end
end