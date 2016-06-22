require 'test_helper'

class TestNotOneOfValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::NotOneOfValidator.new ['mean']
    string = 'friendly'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    validator = Rulix::Validators::NotOneOfValidator.new ['mean']
    string = 'mean'
    result = validator.call string

    assert_equal([false, "cannot be one of [\"mean\"]"], result)
  end
end