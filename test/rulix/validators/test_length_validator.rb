require 'test_helper'

class TestLengthValidator < MiniTest::Test
  def test_call_with_exactly
    validator = Rulix::Validators::LengthValidator.new exactly: 5
    string = 'chars'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call_with_exactly
    validator = Rulix::Validators::LengthValidator.new exactly: 5

    string = 'This string is WAY too long'
    result = validator.call string

    assert_equal([false, "must be exactly 5 characters long"], result)
  end

  def test_call_with_min
    validator = Rulix::Validators::LengthValidator.new min: 5
    string = 'chars'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call_with_min
    validator = Rulix::Validators::LengthValidator.new min: 5
    string = 'Tiny'
    result = validator.call string

    assert_equal([false, "must be at least 5 characters long"], result)
  end

  def test_call_with_max
    validator = Rulix::Validators::LengthValidator.new max: 5
    string = 'chars'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call_with_max
    validator = Rulix::Validators::LengthValidator.new max: 5
    string = 'This string is WAY too long'
    result = validator.call string

    assert_equal([false, "cannot be longer than 5 characters"], result)
  end
end