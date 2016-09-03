# Rulix

Rulix is a gem for defining and using rules to manipulate, validate, and transform datasets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rulix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rulix

## Usage

Rulix is an engine for defining rulesets that you can apply to your datasets. It has two primary functions; Mutation and Validation.

## Rules

Rules in Rulix are, at their core, procs. Anything that can be coerced into a proc can be used as a rule.

```ruby
# Procs and lambdas work fine
-> (value) { value.gsub /\d+/, '' }

# Symbols respond to :to_proc, so they work too
:strip

# Any object that can be coerced into a proc will work!
class DashStripper
  def strip_dashes string
    string.gsub /-/, ''
  end

  def to_proc
    method(:strip_dashes)
  end
end

DashStripper.new
```

#### Using Rules

Rules can be supplied directly in a ruleset as long as they can be coerced into procs with `to_proc`.

```ruby
ruleset = {
  first_name: -> (name) { name.reverse },
  last_name: :strip
}
```

For a more permanent rule definition, you can register a procable object or block under a symbol through the embedded registry for Rulix to use.

```ruby
my_super_neat_transformation = -> (string) { string.upcase.chars.shuffle.join }

Rulix::Mutator.register :make_super_neat, my_super_neat_transformation
```

Then, you can supply the symbol in a Rulix ruleset.

```ruby
dataset = {
  foo: 'oh man this is going to be so cool'
}

rules = {
  foo: :make_super_neat
}

Rulix::Mutator.run dataset, rules
#=> {:foo=>" T OI   INHOHMSNSTS B OIAOEOGGOLC "}
```

#### Configuring Rules

Some rules may need additional definition or configuration based on context. If you are writing a rule that needs additional options passed in, make the options a hash that is either taken as initialization arguments, or as the first argument of your proc.


```ruby
# Configurable proc
trimmer = -> (options, value) { value[0..options[:trim_to] - 1] }

Rulix::Mutator.register :trim, trimmer

{ first_name: { trim: { trim_to: 5 } } }

# Configured procable object
class CharacterRemover
  attr_accessor :character

  def initialize options = nil
    options ||= {}

    self.character = options[:character]
  end

  def remove_from string
    string.gsub character, ''
  end

  def to_proc
    method(:remove_from)
  end
end
```

## Rulesets

Rulix rulesets are just Ruby hashes.

```ruby
ruleset = { first_name: :strip }
```

In order to properly map to a dataset, they need to follow the structure of the dataset that they're validating.

```ruby
ruleset = { first_name: :strip }

# This will work
proper_dataset = { first_name: 'Bob ' }

# This one won't :(
bad_dataset = { person: { first_name: 'Bob ' } }
```

Rulix does support nested hashes in a dataset, as long as the ruleset matches the format.

```ruby
dataset = {
  person: {
    first_name: 'Bob '
  }
}

ruleset = {
  person: {
    first_name: :strip
  }
}
```

Multiple rules can be applied to the same data point in a dataset.

```ruby
dataset = { name: 'Bob   Johnson  ' }

ruleset = { name: [:squeeze_spaces, :strip] }

Rulix::Mutator.run dataset, ruleset
#=> { name: 'Bob Johnson' }
```

## Mutation

You can mutate a dataset with `Rulix::Mutator`. This is most useful for sanitizing user inputs (like params hashes in Rails), but it can be used for any operation that needs to perform consistent mutations on a set of data.

```ruby
dataset = {
  first_name: 'Bob ',
  last_name: 'Johnson '
}

ruleset = {
  first_name: :strip,
  last_name: :strip
}

Rulix::Mutator.run dataset, ruleset
#=> { first_name: 'Bob', last_name: 'Johnson' }
```

See the wiki for a [list of included mutator functions](https://github.com/blarshk/rulix/wiki/List-of-Included-Mutator-Functions).

## Validation

Use `Rulix::Validator` to validate a dataset. `Rulix::Validator.run` will return a `Rulix::Validation` object, which is just hash with a few extra helpful methods (like `valid?` and `error_messages`).

```ruby
dataset = {
  phone: {
    number: '800-555-5555'
  }
}

ruleset = {
  phone: {
    number: [format: /\d{10}/]
  }
}

result = Rulix::Validator.run dataset, ruleset

result.valid?
#=> false
result
#=> { phone: { number: ['does not match format'] } }
result.error_messages
#=> ['Number does not match format']
```

See the wiki for a [list of included validation functions](https://github.com/blarshk/rulix/wiki/List-of-Included-Validation-Functions). If you have a validation function that you like that you think should be included in Rulix's base set, submit a pull request!

### Validating with ActiveRecord

Rulix comes with a plugin class that you can use to validate ActiveRecord models.

```ruby
class User < ActiveRecord::Base
  validates :email, uniqueness: true

  validates_with Rulix::ActiveRecordValidator, ruleset: {
    email: { format: { pattern: /.*@.*/, message: 'is not an email address' } }
  }
end

user = User.new email: 'foobar'

user.valid?
#=> false
user.errors.full_messages
#=> ['Email is not an email address']
```

The adapter can be used alongside ActiveRecord's own validators, so you can keep using ActiveRecord to validate the things it's good at, and delegate the rest to Rulix!

## Custom Validators and Mutators

You can write your own mutators and validators and make them available to Rulix for building rulesets as long as they implement their respective interfaces.

#### Custom Mutators

A mutator changes data, so its only interface requirement is that it returns a modified version of the supplied argument.

```ruby
string = 'A String of Sorts'
data = { foo: string }
bad_rule = -> (str) { [str] }

rules = { foo: [bad_rule, :strip] }

Rulix::Mutator.run data, rules
#=> NoMethodError: undefined method `strip' for ["A String of Sorts"]:Array
```

#### Custom Validators

Validators should return `true` if the rule is satisfied, and `[false, error_message]` if the validation fails. Rulix will run all supplied validations against the left-hand argument and compile the errors into a single array in place.

`Rulix::Validator` will always return an array under the given validated key, even if there is only one error.

```ruby
Rulix::Validator.register :doesnt_end_in_oo do |val|
  val.end_with?('oo') ? [false, 'ends in oo'] : true
end

data = {
  my_field: 'foo'
}

rules = {
  my_field: [:number, :doesnt_end_in_oo]
}

Rulix::Validator.run data, rules
#=> { my_field: ['is not a number', 'ends in oo'] }
```

The `error_message` compontent of your validations can be anything you want; the results will be concatenated into a single array.

```ruby
Rulix::Validator.register :has_a_digit do |val|
  /\d/.match(val) ? true : [false, { code: '001', message: 'The value supplied does not contain a digit!' }]
end

data = {
  my_field: 'bar'
}

rules = {
  my_field: [:has_a_digit]
}

Rulix::Validator.run data, rules
#=> { my_field: [{ code: '001', message: 'The value supplied does not contain a digit!' }] }
```

## Contributing

1. Fork it ( https://github.com/blarshk/rulix/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request