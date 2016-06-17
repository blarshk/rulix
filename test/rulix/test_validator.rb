require 'test_helper'

class TestValidator < MiniTest::Test
  class Foo
    attr_accessor :ssn
  end

  def test_valid?
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

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
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

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
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

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
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

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
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

    data = Foo.new
    data.ssn = '123-12-1234'

    rules = {
      ssn: [format: { pattern: /\d{9}/, message: 'does not match format' }]
    }
    
    result = Rulix::Validator.errors data, rules

    assert_equal({ ssn: ['does not match format'] }, result)
  end

  def test_errors_against_nested_hash
    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

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
      first_name: [:alpha_only, no_spaces: { message: 'contains spaces' }],
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
    Rulix::Validator.register :email do |val|
      /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(val) ? true : [false, 'is not an email address']
    end

    Rulix::Validator.register :format do |options, val|
      options[:pattern] === val ? true : [false, options[:message]]
    end

    data = {
      first_name: 'Bob',
      last_name: 'Johnson',
      email: 'foo@bar',
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
        zip: [length: { max: 5 }]
      }
    }

    result = Rulix::Validator.errors data, rules

    expected_result = {
      email: ['is not an email address'],
      profile: {
        ssn: ['does not match format']        
      },
      address: {
        state: ['is too long'],
        zip: ['is too long']
      }
    }

    assert_equal(expected_result, result)
  end
end