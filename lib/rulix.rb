require_relative './rulix/version'
require_relative './rulix/registry'
require_relative './rulix/mutator'
require_relative './rulix/validator'
require_relative './rulix/core_ext/hash'

Dir[File.dirname(__FILE__) + '/rulix/validators/*.rb'].each { |f| require f }

module Rulix; end