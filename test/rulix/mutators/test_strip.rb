require 'test_helper'

class TestStrip < MiniTest::Test
  def test_call
    validator = Rulix::Mutators::Strip.new '-'
    string = '123-12-1234'
    result = validator.call string

    assert_equal '123121234', result
  end

  def test_call_with_regex
    validator = Rulix::Mutators::Strip.new(/[^a-zA-Z0-9]/)
    string = '123-12-1234'
    result = validator.call string

    assert_equal '123121234', result
  end

  def test_incorrect_argument
    validator = Rulix::Mutators::Strip.new '-'

    assert_raises(ArgumentError) { validator.call(123) }
  end
end