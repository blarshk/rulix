require 'pry'
require 'minitest/autorun'
require 'rulix'
require 'validator_test'

class Foo
  attr_accessor :ssn, :bar

  def initialize options = nil
    options ||= {}
    self.ssn = options[:ssn]
    self.bar = options[:bar]
  end
end

class Bar
  attr_accessor :value

  def initialize options = nil
    options ||= {}

    self.value = options[:value]
  end
end