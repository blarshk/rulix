require_relative './format_validator'

validator = Rulix::Validators::FormatValidator.new(
  pattern: /.*@.*/, 
  message: 'is not an email address'
)

Rulix::Validator.register :email, validator