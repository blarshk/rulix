require 'test_helper'

class TestRulixBase < MiniTest::Test
  def test_maintains_key_types
    data = {
      'foo' => 'baz   '
    }

    rules = {
      foo: [:strip]
    }

    result = Rulix::Base.run data, rules do |data_point, operations|
      operations.reduce(data_point) do |d, o|
        o.call(d)
      end
    end

    expected_result = {
      'foo' => 'baz'
    }

    assert_equal expected_result, result
  end
end