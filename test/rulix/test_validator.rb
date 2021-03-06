require 'test_helper'

class TestValidator < MiniTest::Test
  def test_validate
    data = {
      ssn: '123121234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.run data, rules

    assert_equal Rulix::Validation, result.class
  end

  def test_validate_error_message_integration
    data = {
      ssn: '123-12-1234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.run data, rules

    assert_equal ['Ssn does not match format'], result.error_messages
  end

  def test_errors
    data = {
      ssn: '123121234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.run data, rules

    assert_equal({}, result)
  end

  def test_errors_with_failed_validations
    data = {
      ssn: '123-12-1234'
    }

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }

    result = Rulix::Validator.run data, rules

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
    
    result = Rulix::Validator.run data, rules

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

    result = Rulix::Validator.run data, rules

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

    result = Rulix::Validator.run data, rules

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

    result = Rulix::Validator.run data, rules

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

    result = Rulix::Validator.run data, rules

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

    result = Rulix::Validator.run data, rules

    expected_result = {
      foo: ['is not one of ["bar", "baz"]']
    }

    assert_equal expected_result, result
  end

  def test_array_of_values_validations
    data = {
      genres: ['pop', 'rock']
    }

    rules = {
      genres: [one_of: ['pop', 'rock']]
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_array_of_values_validation_errors
    data = {
      genres: ['country', 'hip-hop']
    }

    rules = {
      genres: [one_of: ['pop', 'rock']]
    }

    result = Rulix::Validator.run data, rules

    expected_result = {
      genres: ["is not one of [\"pop\", \"rock\"]", "is not one of [\"pop\", \"rock\"]"]
    }

    assert_equal expected_result, result
  end

  def test_array_of_hashes_validations
    data = {
      songs: [
        { title: 'Fools', duration: '185' },
        { title: 'More Fools', duration: '260' },
      ]
    }

    rules = {
      songs: [
        { duration: [format: /\d{3}/] }
      ]
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_array_of_objects_validations
    data = Foo.new({
      ssn: '123121234',
      bar: Bar.new({
        value: ['baz']
      })
    })

    rules = {
      ssn: :number,
      bar: {
        value: [one_of: ['baz', 'qix']]
      }
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_array_of_objects_and_hashes_validations
    data = Foo.new({
      ssn: '123121234',
      bar: Bar.new({
        value: [{ id: 'C123' }]
      })
    })

    rules = {
      ssn: :number,
      bar: {
        value: [{ id: [:number] }]
      }
    }

    result = Rulix::Validator.run data, rules

    expected_result = {
      bar: {
        value: [{ id: ['is not a number'] }]
      }
    }

    assert_equal expected_result, result
  end

  def test_allow_nil_integration
    data = {
      foo: 'bar'
    }

    rules = {
      blar: [:allow_nil, :number]
    }

    result = Rulix::Validator.valid? data, rules

    assert_equal true, result
  end

  def test_passed_allow_nil_integration
    data = {
      foo: 'bar'
    }

    rules = {
      foo: [:allow_nil, :number]
    }

    result = Rulix::Validator.run data, rules

    expected_result = {
      foo: ['is not a number']
    }

    assert_equal expected_result, result
  end
end