require 'test_helper'

class TestFormatValidator < ValidatorTest
  def test_call
    validate_with '123121234', :pass, pattern: /\d{9}/
  end

  def test_error_call
    validate_with 'This one totally does not match the format', :fail, pattern: /\d{9}/
  end

  def test_init_without_options
    validate_with '123121234', :pass, /\d{9}/
  end

  def klass
    Rulix::Validators::FormatValidator
  end

  def error_message
    'does not match format'
  end
end