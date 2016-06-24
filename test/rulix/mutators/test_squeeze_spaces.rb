require 'test_helper'

class TestSqueezeSpaces < MiniTest::Test
  def test_call
    validator = Rulix::Mutators::SqueezeSpaces.new
    string = 'Too  many   spaces   '
    result = validator.call string

    assert_equal 'Too many spaces ', result
  end

  def test_incorrect_argument
    validator = Rulix::Mutators::SqueezeSpaces.new

    assert_raises(ArgumentError) { validator.call(123) }
  end
end