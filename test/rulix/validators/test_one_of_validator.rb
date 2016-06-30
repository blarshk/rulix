require 'test_helper'

class TestOneOfValidator < ValidatorTest
  def klass
    Rulix::Validators::OneOfValidator
  end

  def test_call
    validate_with 2, :pass, [1,2,3]
  end

  def test_error_call
    validator = Rulix::Validators::OneOfValidator.new [1, 2, 3]
    value = 5
    result = validator.call value

    assert_equal([false, "is not one of [1, 2, 3]"], result)
  end
end