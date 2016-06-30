class ValidatorTest < MiniTest::Test
  def klass
    raise
  end

  def error_message
    raise
  end

  protected
    def validate_with value, expectation, *args
      if args.empty?
        validator = klass.new        
      else
        validator = klass.new *args
      end

      result = validator.call value

      if expectation == :pass
        validated result
      else
        failed result
      end
    end

    def validated result
      assert_equal true, result
    end

    def failed result
      assert_equal([false, error_message], result)
    end
end