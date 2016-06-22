require 'test_helper'

class TestEmailValidator < MiniTest::Test
  def test_call
    validator = Rulix::Validators::EmailValidator.new
    string = 'mitch@nav.com'
    result = validator.call string

    assert_equal true, result
  end

  def test_error_call
    validator = Rulix::Validators::EmailValidator.new
    string = 'notanemail'
    result = validator.call string

    assert_equal([false, "is not an email address"], result)
  end
end