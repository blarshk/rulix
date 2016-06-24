require 'test_helper'

class TestDefault < MiniTest::Test
  def test_call
    mutator = Rulix::Mutators::Default.new ''
    result = mutator.call nil

    assert_equal '', result
  end

  def test_call_with_integer
    mutator = Rulix::Mutators::Default.new 0
    result = mutator.call nil

    assert_equal 0, result
  end

  def test_call_with_empty_array
    mutator = Rulix::Mutators::Default.new []
    result = mutator.call nil

    assert_equal [], result
  end

  def test_call_with_existing_value
    mutator = Rulix::Mutators::Default.new ''
    result = mutator.call 'foo'

    assert_equal 'foo', result
  end
end