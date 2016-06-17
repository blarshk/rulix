require 'test_helper'

class TestMutator < MiniTest::Test
  def test_run_with_hash_args
    data = {
      zip: '840958'
    }

    rules = {
      zip: [length: 5]
    }

    Rulix::Mutator.register :length, -> (length, val) { val[0..length - 1] }

    result = Rulix::Mutator.run data, rules

    assert_equal '84095', result[:zip]
  end

  def test_run_with_unregistered_hash_args
    data = {
      zip: '840958'
    }

    rules = {
      zip: [coolness: 5]
    }

    assert_raises(ArgumentError) { Rulix::Mutator.run data, rules }
  end

  def test_run_with_symbol_args
    data = {
      name: 'A cool toy'
    }

    rules = {
      name: :upcase
    }

    result = Rulix::Mutator.run data, rules

    assert_equal 'A COOL TOY', result[:name]
  end

  def test_run_with_proc_args
    data = {
      price: 29.99
    }

    rules = {
      price: -> (price) { (price * 100).round }
    }

    result = Rulix::Mutator.run data, rules

    assert_equal 2999, result[:price]
  end

  def test_run_with_different_keys
    data = {
      first_name: 'Bobbo',
      last_name: 'Johnson'
    }

    rules = {
      first_name: :upcase
    }

    result = Rulix::Mutator.run data, rules

    assert_equal 'BOBBO', result[:first_name]
    assert_equal 'Johnson', result[:last_name]
  end
end