require 'test_helper'

class TestValidation < MiniTest::Test
  def test_valid?
    validation = Rulix::Validation.new({ foo: ["can't be bar"] })
    result = validation.valid?

    assert_equal false, result
  end

  def test_valid_when_valid
    validation = Rulix::Validation.new({})
    result = validation.valid?

    assert_equal true, result
  end

  def test_error_messages
    validation = Rulix::Validation.new({ foo: ["can't be bar"] })
    result = validation.error_messages

    assert_equal ["Foo can't be bar"], result
  end

  def test_nested_error_messages
    validation = Rulix::Validation.new({ foo: { bar: ['is a bad thing'] } })
    result = validation.error_messages

    assert_equal ['Bar is a bad thing'], result
  end

  def test_thrice_nested_error_messages
    validation = Rulix::Validation.new({ foo: { bar: { baz: ['is a bad thing'] } } } )
    result = validation.error_messages

    assert_equal ['Baz is a bad thing'], result
  end

  def test_error_messages_with_hash
    validation = Rulix::Validation.new({ foo: [{ code: '001', type: 'bad_foo_error' }] })

    result = validation.error_messages
    assert_equal [{ code: '001', type: 'bad_foo_error' }], result
  end

  def test_error_messages_with_complex_result_set
    validation = Rulix::Validation.new({ foo: { baz: { blar: ['shk'] }, bar: [{ code: '001', type: 'bad_foo_error' }] } })
    
    result = validation.error_messages
    assert_equal ['Blar shk', { code: '001', type: 'bad_foo_error' }], result
  end
end