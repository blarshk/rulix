require 'test_helper'

class TestNumberValidator < MiniTest::Test
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

  private

    def validate_with value, expectation
      validator = Rulix::Validators::NumberValidator.new
      result = validator.call value

      if expectation == :pass
        validated result
      else
        failed result
      end
    end

    def validated result
      assert_equal true, result
    end

    def failed result
      assert_equal([false, "is not a number"], result)
    end
end