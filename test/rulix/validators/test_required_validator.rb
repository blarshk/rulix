require 'test_helper'

class TestRequiredValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::RequiredValidator.new
    value = 'foo'

    result = validator.call value

    assert_equal true, result
  end

  def test_failed_call
    validator = Rulix::Validators::RequiredValidator.new
    value = nil

    result = validator.call value

    assert_equal([false, 'is required'], result)
  end
end