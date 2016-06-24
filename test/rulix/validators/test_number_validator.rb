require 'test_helper'

class TestNumberValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::NumberValidator.new
    value = 123
    result = validator.call value

    assert_equal true, result
  end

  def test_call_with_num_string
    validator = Rulix::Validators::NumberValidator.new
    value = '123'
    result = validator.call value

    assert_equal true, result
  end

  def test_with_blank_string
    validator = Rulix::Validators::NumberValidator.new
    value = ''
    result = validator.call value

    assert_equal([false, "is not a number"], result)
  end

  def test_error_call
    validator = Rulix::Validators::NumberValidator.new
    value = '123 Main Street'
    result = validator.call value

    assert_equal([false, "is not a number"], result)
  end
end