require 'test_helper'

class TestTruncate < MiniTest::Test
  def test_call
    validator = Rulix::Mutators::Truncate.new 5
    string = '84095-0475'
    result = validator.call string

    assert_equal '84095', result
  end

  def test_incorrect_argument
    validator = Rulix::Mutators::Truncate.new 5

    assert_raises(ArgumentError) { validator.call(123) }
  end
end