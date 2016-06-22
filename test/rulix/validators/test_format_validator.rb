require 'test_helper'

class TestFormatValidator < MiniTest::Test
  def test_call
    format = /\d{9}/
    validator = Rulix::Validators::FormatValidator.new pattern: format
    string = '123121234'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    format = /\d{9}/
    validator = Rulix::Validators::FormatValidator.new pattern: format
    string = 'This one totally does not match the format'
    result = validator.call string

    assert_equal([false, "does not match format"], result)
  end

  def test_init_without_options
    format = /\d{9}/
    validator = Rulix::Validators::FormatValidator.new format
    string = '123121234'
    result = validator.call string

    assert_equal true, result
  end
end