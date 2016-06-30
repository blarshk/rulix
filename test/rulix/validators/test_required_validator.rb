require 'test_helper'

class TestRequiredValidator < ValidatorTest
  def klass
    Rulix::Validators::RequiredValidator
  end

  def error_message
    'is required'
  end

  def test_call
    validate_with 'foo', :pass
  end

  def test_failed_call
    validate_with nil, :fail
  end
end