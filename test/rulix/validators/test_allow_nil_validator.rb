require 'test_helper'

class TestAllowNilValidator < ValidatorTest
  def test_call
    assert_raises(AllowableNil) { klass.new.call(nil) }
  end

  def test_with_value_present
    validate_with '', :pass
  end

  def klass
    Rulix::Validators::AllowNilValidator
  end
end