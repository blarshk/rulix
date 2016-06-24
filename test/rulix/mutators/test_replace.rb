require 'test_helper'

class TestReplace < MiniTest::Test
  def test_call
    validator = Rulix::Mutators::Replace.new ['-', '_']
    string = '123-12-1234'
    result = validator.call string

    assert_equal '123_12_1234', result
  end

  def test_call_with_regex
    validator = Rulix::Mutators::Replace.new [/-/, '_']
    string = '123-12-1234'
    result = validator.call string

    assert_equal '123_12_1234', result
  end

  def test_incorrect_argument
    validator = Rulix::Mutators::Replace.new ['-', '_']

    assert_raises(ArgumentError) { validator.call(123) }
  end
end