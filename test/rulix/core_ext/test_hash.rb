require 'test_helper'

class TestHash < MiniTest::Test
  def test_deep_merge
    base_hash = {
      foo: {
        bar: 'baz'
      }
    }

    merge_hash = {
      foo: {
        blar: 'shk'
      }
    }

    expected_result = {
      foo: {
        bar: 'baz',
        blar: 'shk'
      }
    }

    merged_hash = base_hash.deep_merge merge_hash

    assert_equal expected_result, merged_hash
  end

  def test_deep_compact
    hash = {
      foo: {
        bar: {},
        baz: 'hai'
      }
    }

    compacted = hash.deep_compact

    expected_result = {
      foo: {
        baz: 'hai'
      }
    }

    assert_equal expected_result, compacted
  end

  def test_deep_reject
    base_hash = {
      foo: {
        bar: 'baz',
        blar: 'shk'
      }
    }

    rejected = base_hash.deep_reject { |key, val| val == 'shk' }

    expected_result = {
      foo: {
        bar: 'baz'
      }
    }

    assert_equal expected_result, rejected
  end
end