require 'test_helper'

class TestFormatValidator < MiniTest::Test
  def test_call
    format = /\d{9}/
    validator = Rulix::Validators::FormatValidator.new format: format
    string = '123121234'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    format = /\d{9}/
    validator = Rulix::Validators::FormatValidator.new format: format
    string = 'This one totally does not match the format'
    result = validator.call string

    assert_equal([false, "does not match format"], result)
  end
end