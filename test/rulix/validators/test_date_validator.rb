require 'test_helper'

class TestDateValidator < ValidatorTest
  def test_call
    validate_with '2015-01-01', :pass
  end

  def test_with_blank_string
    validate_with '', :fail
  end

  def test_error_call
    validate_with '2015', :fail
  end

  def klass
    Rulix::Validators::DateValidator
  end

  def error_message
    "is not a date"
  end
end