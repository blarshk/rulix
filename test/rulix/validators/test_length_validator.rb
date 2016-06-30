require 'test_helper'

class TestLengthValidator < ValidatorTest
  def klass
    Rulix::Validators::LengthValidator
  end

  def error_message
    ''
  end

  def test_call_with_exactly
    validate_with 'chars', :pass, exactly: 5
  end

  def test_error_call_with_exactly
    validator = Rulix::Validators::LengthValidator.new exactly: 5

    string = 'This string is WAY too long'
    result = validator.call string

    assert_equal([false, "must be exactly 5 characters long"], result)
  end

  def test_call_with_min
    validate_with 'chars', :pass, min: 5
  end

  def test_error_call_with_min
    validator = Rulix::Validators::LengthValidator.new min: 5
    string = 'Tiny'
    result = validator.call string

    assert_equal([false, "must be at least 5 characters long"], result)
  end

  def test_min_with_no_max
    validate_with 'Tinyish', :pass, min: 5
  end

  def test_call_with_max
    validate_with 'chars', :pass, max: 5
  end

  def test_error_call_with_max
    validator = Rulix::Validators::LengthValidator.new max: 5
    string = 'This string is WAY too long'
    result = validator.call string

    assert_equal([false, "cannot be longer than 5 characters"], result)
  end
end