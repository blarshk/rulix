require 'test_helper'

class TestNotOneOfValidator < ValidatorTest
  def klass
    Rulix::Validators::NotOneOfValidator
  end

  def test_call
    validate_with 'friendly', :pass, ['mean']
  end

  def test_error_call
    validator = Rulix::Validators::NotOneOfValidator.new ['mean']
    string = 'mean'
    result = validator.call string

    assert_equal([false, "cannot be one of [\"mean\"]"], result)
  end
end