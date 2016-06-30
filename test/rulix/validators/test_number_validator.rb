require 'test_helper'

class TestNumberValidator < ValidatorTest
  def test_call
    validate_with 123, :pass
  end

  def test_call_with_num_string
    validate_with '123', :pass
  end

  def test_with_blank_string
    validate_with '', :fail
  end

  def test_error_call
    validate_with '123 Main Street', :fail
  end

  def test_call_with_float_string
    validate_with '123.5', :pass
  end

  def test_call_with_signed_int
    validate_with '-52', :pass
  end

  def klass
    Rulix::Validators::NumberValidator
  end

  def error_message
    'is not a number'
  end
end