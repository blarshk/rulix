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

  def test_run_with_default_integration
    data = {
      first_name: 'Bobbo'
    }

    rules = {
      last_name: [default: '']
    }

    result = Rulix::Mutator.run data, rules

    assert_equal 'Bobbo', result[:first_name]
    assert_equal '', result[:last_name]
  end

  def test_run_with_array_of_values
    data = {
      genres: ['pop', 'rock']
    }

    rules = {
      genres: [:upcase]
    }

    result = Rulix::Mutator.run data, rules

    assert_equal ['POP', 'ROCK'], result[:genres]
  end

  def test_run_with_array_of_objects
    data = {
      phones_attributes: [
        { number: '801-111-1111' },
        { number: '801-111-1112' }
      ]
    }

    rules = {
      phones_attributes: [
        { number: [strip: /[^\d]+/] }
      ]
    }

    result = Rulix::Mutator.run data, rules

    assert_equal '8011111111', result[:phones_attributes][0][:number]
    assert_equal '8011111112', result[:phones_attributes][1][:number]
  end
end