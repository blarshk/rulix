require 'test_helper'

class TestValidator < MiniTest::Test
  class Foo
    attr_accessor :ssn, :bar

    def initialize options = nil
      options ||= {}
      self.ssn = options[:ssn]
      self.bar = options[:bar]
    end
  end

  class Bar
    attr_accessor :value

    def initialize options = nil
      options ||= {}

      self.value = options[:value]
    end
  end

  def test_valid?
    data = {
      ssn: '123121234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_with_failed_validations
    data = {
      ssn: '123-12-1234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal false, result
  end

  def test_errors
    data = {
      ssn: '123121234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.errors data, rules

    assert_equal({}, result)
  end

  def test_errors_with_failed_validations
    data = {
      ssn: '123-12-1234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.errors data, rules

    assert_equal({ ssn: ['does not match format'] }, result)
  end

  def test_errors_against_object
    data = Foo.new({
      ssn: '123-12-1234',
      bar: Bar.new({
        value: 'hacks'
      })
    })

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }],
      bar: {
        value: -> (val) { val == 'hacks' ? [false, "can't be hacks"] : true }
      }
    }
    
    result = Rulix::Validator.errors data, rules

    assert_equal({ ssn: ['does not match format'], bar: { value: ["can't be hacks"] } }, result)
  end

  def test_errors_against_nested_hash
    Rulix::Validator.register :no_spaces do |options, val|
      val.scan(/\s/).empty? ? true : [false, options[:message]]
    end

    data = {
      first_name: '123 Boi',
      profile: {
        ssn: '123-12-1234'
      }
    }

    rules = {
      first_name: [:alpha, no_spaces: { message: 'contains spaces' }],
      profile: {
        ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
      }
    }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      first_name: ["contains non-alpha characters", "contains spaces"],
      profile: {
        ssn: ['does not match format']        
      }
    }

    assert_equal(expected_result, result)
  end

  def test_complex_dataset
    data = {
      first_name: 'Bob',
      last_name: 'Johnson',
      email: 'foobar',
      profile: {
        ssn: '123-12-1234'
      },
      address: {
        street: '123 Main Street',
        city: 'South Jordan',
        state: 'utah',
        zip: '840951'
      }
    }

    rules = { 
      email: :email,
      profile: {
        ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]    
      },
      address: {
        state: [length: { exactly: 2 }],
        zip: [length: { max: 5, min: 4 }]
      }
    }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      email: ['is not an email address'],
      profile: {
        ssn: ['does not match format']        
      },
      address: {
        state: ["must be exactly 2 characters long"],
        zip: ["cannot be longer than 5 characters"]
      }
    }

    assert_equal(expected_result, result)
  end

  def test_validation_against_empty_field
    data = {}
    rules = { first_name: :required }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      first_name: ['is required']
    }

    assert_equal expected_result, result
  end
  
  def test_required_integration
    data = { first_name: 'Bob' }
    rules = { first_name: :required }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_required_integration_errors
    data = {}
    rules = { first_name: :required }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      first_name: ['is required']
    }

    assert_equal expected_result, result
  end

  def test_one_of_integration
    data = { foo: 'bar' }
    rules = { foo: { one_of: ['bar', 'baz'] } }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_one_of_integration_errors
    data = { foo: 'blar' }
    rules = { foo: { one_of: ['bar', 'baz'] } }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      foo: ['is not one of ["bar", "baz"]']
    }

    assert_equal expected_result, result
  end
end