require 'test_helper'

class TestStringValidator < ValidatorTest
  def test_call
    validate_with 'foo', :pass
  end

  def test_with_nil
    validate_with nil, :fail
  end

  def test_with_non_string
    validate_with 123, :fail
  end

  def klass
    Rulix::Validators::StringValidator
  end

  def error_message
    'is not a string'
  end
end