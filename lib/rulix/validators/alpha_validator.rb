require_relative './format_validator'

validator = Rulix::Validators::FormatValidator.new(
  pattern: /^[a-zA-Z\s?]*$/,
  message: "contains non-alpha characters"
)

Rulix::Validator.register :alpha, validator