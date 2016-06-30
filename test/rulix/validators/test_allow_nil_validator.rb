require 'test_helper'

class TestAllowNilValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::AllowNilValidator.new
    value = nil

    assert_raises(AllowableNil) { result = validator.call value }
  end

  def test_with_value_present
    validator = Rulix::Validators::AllowNilValidator.new
    value = ''
    result = validator.call value

    assert_equal true, result
  end
end