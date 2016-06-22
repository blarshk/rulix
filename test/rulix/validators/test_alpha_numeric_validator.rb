require 'test_helper'

class TestAlphaNumericValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::AlphaNumericValidator.new
    string = 'Alphanumeric Only Dawg1'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    validator = Rulix::Validators::AlphaNumericValidator.new
    string = 'Not AlphaNum 1 Only! Aw, snap'
    result = validator.call string

    assert_equal([false, "contains non-alpha-numeric characters"], result)
  end
end