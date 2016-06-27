require 'test_helper'

class TestDateValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::DateValidator.new
    value = '2015-01-01'
    result = validator.call value

    assert_equal true, result
  end

  def test_with_blank_string
    validator = Rulix::Validators::DateValidator.new
    value = ''
    result = validator.call value

    assert_equal([false, "is not a date"], result)
  end

  def test_error_call
    validator = Rulix::Validators::DateValidator.new
    value = '2015'
    result = validator.call value

    assert_equal([false, "is not a date"], result)
  end
end