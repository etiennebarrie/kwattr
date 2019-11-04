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
    yield @bar if block_given?
  end
end
BarInitialize.new # => #<BarInitialize @foo=42, @bar=21>
```

The prepended `initialize` passes on any block it receives, so you can yield
from your `initialize` as usual.

```ruby
default_bar = nil
BarInitialize.new { |bar| default_bar = bar }
default_bar # => 21
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

### useful exception messages

When it can, kwattr tries to extract the required keyword arguments from the
super method to show more useful exception messages.

```ruby
class FooBar2
  kwattr :foo

  def initialize(bar:)
  end
end
FooBar2.new
# Ruby 2.2 and later: ArgumentError: missing keywords: bar, foo
# Rubinius:           ArgumentError: missing keyword: foo
```

## compatibility

* **Ruby 2.6**, **Ruby 2.5**, **Ruby 2.4**,**Ruby 2.3**, **Ruby 2.2**,
  **TruffleRuby** and **JRuby 9000** are fully supported.

* **Rubinius** is supported, but exceptions don't include keywords from
  `super`.

## free features

*kwattr has no specific code to support those, but they work and are supported
use cases.*

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

Bug reports and pull requests are welcome on GitHub at
https://github.com/etiennebarrie/kwattr. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KWattr project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/etiennebarrie/kwattr/blob/master/CODE_OF_CONDUCT.md).
