# KWattr

Keyword arguments meet `attr_reader` and `initialize`:

```ruby
class FooBar
  kwattr :foo, bar: 21
end

foobar = FooBar.new(foo: 42) # => #<FooBar @foo=42, @bar=21>
foobar.foo # => 42
foobar.bar # => 21
```

instead of

```ruby
class FooBar
  attr_reader :foo, :bar

  def initialize(foo:, bar: 21)
    @foo = foo
    @bar = bar
  end
end
```

### initialize

The provided `initialize` is prepended so there's no need to call `super`, and
attributes are already set when your code is reached.

```ruby
class BarInitialize
  kwattr foo: 42

  def initialize(bar: 2)
    @bar = foo / bar
  end
end
BarInitialize.new # => #<BarInitialize @foo=42, @bar=21>
```

### return value

It returns the list of keyword attributes so you can combine with methods like
`Module#protected`.

```ruby
class FooProtected
  protected *kwattr(foo: 42)
end
FooProtected.new # => #<FooProtected @foo=42>
FooProtected.protected_instance_methods # => [:foo]
```

### subclass

```ruby
class Foo
  kwattr :foo
end

class FooWithBar < Foo
  kwattr :bar
end

FooWithBar.new(foo: 42, bar: 21) # => #<FooWithBar @foo=42, @bar=21>
```

### include

```ruby
module Mod
  kwattr :mod
end

class Inc
  include Mod
end

Inc.new(mod: 42)
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
