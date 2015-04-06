# KWattr

Keyword arguments meet attribute definitions and initialize:

```ruby
class FooBar
  kwattr :foo, :bar
end

foobar = FooBar.new foo: 42, bar: 21
# => #<FooBar @foo=42, @bar=21>
foobar.foo # => 42
foobar.bar # => 21
```

instead of

```ruby
class FooBar
  attr_reader :foo, :bar

  def initialize(foo:, bar:)
    @foo = foo
    @bar = bar
  end
end
```

### Default values

```ruby
class Foo
  kwattr foo: 42
end

Foo.new
# => #<Foo @foo=42>
```

### Overriding initialize

The default initialize is prepended so there's no need to call `super` in
initialize, and attributes are already set.

```ruby
$overridden = []

class Overridden
  kwattr foo: 42

  def initialize
    $overridden << foo
  end
end

Overridden.new
Overridden.new foo: 21
$overridden
# => [42, 21]
```

### Subclass

```ruby
class Bar < Foo
  kwattr :bar
end

Bar.new bar: 42
# => #<Bar @foo=42, @bar=42>
```

### Include

```ruby
module Mod
  kwattr :mod
end

class Inc
  include Mod
end

Inc.new mod: 42
```

## See also

* https://github.com/mbj/concord
* https://github.com/ahoward/fattr
* https://github.com/solnic/virtus

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kwattr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kwattr

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/etiennebarrie/kwattr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
