require_relative './format_validator'

validator = Rulix::Validators::FormatValidator.new(
  pattern: /^[a-zA-Z0-9\s?]*$/,
  message: "contains non-alpha-numeric characters"
)

Rulix::Validator.register :alphanum, validator