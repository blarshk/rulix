require 'test_helper'

class TestAlphaValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::AlphaValidator.new
    string = 'Alpha Only Dawg'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    validator = Rulix::Validators::AlphaValidator.new
    string = 'Not Alpha Only! Aw, snap'
    result = validator.call string

    assert_equal([false, "contains non-alpha characters"], result)
  end
end