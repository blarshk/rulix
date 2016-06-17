# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rulix/version'

Gem::Specification.new do |spec|
  spec.name          = "rulix"
  spec.version       = Rulix::VERSION
  spec.authors       = ["Mitch Monsen"]
  spec.email         = ["mmonsen7@gmail.com"]

  spec.summary       = "Simple data manipulation and validation through rulesets"
  spec.description   = "Rulix lets you fold complex rulesets onto complex data structures; useful for validation, data sanitization, and mutation."
  spec.homepage      = "https://github.com/blarshk/rulix"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
