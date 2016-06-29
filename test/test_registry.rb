require 'test_helper'

class TestRegistry < Minitest::Test
  # <REGISTRY-INCLUDED>.register :symbol, procable
  # to register a rule to be used in constructing rulesets

  class FakeRegistry
    include Rulix::Registry
  end

  def test_register
    space_squeezer = -> (value) { value.squeeze ' ' }

    FakeRegistry.register :squeeze_spaces, space_squeezer

    refute_nil FakeRegistry.instance_variable_get('@registry')[:squeeze_spaces]
  end

  # Alternate block syntax for defining/registering rules
  def test_register_block
    FakeRegistry.register :chomp do |val|
      val.chomp
    end

    refute_nil FakeRegistry.instance_variable_get('@registry')[:chomp]
  end

  # If we can't coerce the symbol's arg into a proc, we should
  # throw an argument error
  def test_register_unprocable
    label = :random
    unprocable = 'foo'

    assert_raises(ArgumentError) { FakeRegistry.register label, unprocable }
  end

  def test_string_for_symbol_registration
    space_squeezer = -> (value) { value.squeeze ' ' }

    FakeRegistry.register :squeeze_spaces, space_squeezer

    op = FakeRegistry.get_operation 'squeeze_spaces'

    result = op.call("Foo   and    Bar")

    assert_equal 'Foo and Bar', result
  end
end