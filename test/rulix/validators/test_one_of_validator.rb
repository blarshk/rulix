require 'test_helper'

class TestOneOfValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::OneOfValidator.new [1, 2, 3]
    value = 2
    result = validator.call value

    assert_equal true, result
  end

  def test_error_call
    validator = Rulix::Validators::OneOfValidator.new [1, 2, 3]
    value = 5
    result = validator.call value

    assert_equal([false, "is not one of [1, 2, 3]"], result)
  end
end