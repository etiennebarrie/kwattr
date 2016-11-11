require 'kwattr'
puts "kwattr v#{KWAttr::VERSION}"

def p(value)
  super if $DEBUG
  value
end

class Test
  kwattr :foo, :bar
end

test = Test.new(foo: 42, bar: 21)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21

def raises?(exception_class)
  yield
  return
rescue exception_class
  return p $!
end

fail unless raises?(ArgumentError) { Test.new }
fail unless raises?(ArgumentError) { Test.new(foo: 42) }
fail unless raises?(ArgumentError) { Test.new(foo: 42, bar: 21, baz: 43) }

class Discrete
  protected *kwattr(:foo, bar: 21)

  def pfoo
    foo
  end

  def pbar
    bar
  end
end

test = Discrete.new(foo: 42)
fail unless p(test.pfoo) == 42
fail unless p(test.pbar) == 21
fail unless raises?(NoMethodError) { test.foo }
fail unless raises?(NoMethodError) { test.bar }

class Test2
  kwattr :titi
  kwattr :toto
end

test = Test2.new(titi: 1, toto: 2)
fail unless p(test.titi) == 1
fail unless p(test.toto) == 2

class TestDescendant < Test
  kwattr :baz
end

test = TestDescendant.new(foo: 42, bar: 21, baz: 14)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
fail unless p(test.baz) == 14

class TestInitialize
  kwattr :foo, :bar
  attr :baz

  def initialize(baz: 42)
    @baz = baz / 3
  end
end

test = TestInitialize.new(foo: 42, bar: 21)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
fail unless p(test.baz) == 14
test = TestInitialize.new(foo: 42, bar: 21, baz: 21)
fail unless p(test.baz) == 7

class TestPositional
  kwattr :foo, :bar
  attr :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

test = TestPositional.new(1, 2, foo: 42, bar: 21)
fail unless p(test.x) == 1
fail unless p(test.y) == 2
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21

class TestOptionalKeyword
  kwattr foo: 42
  kwattr :bar
end

test = TestOptionalKeyword.new(bar: 21)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
test = TestOptionalKeyword.new(foo: 21, bar: 42)
fail unless p(test.foo) == 21

class TestPositionalDescendant < TestPositional
  kwattr baz: 14
end

test = TestPositionalDescendant.new(1, 2, foo: 42, bar: 21)
fail unless p(test.x) == 1
fail unless p(test.y) == 2
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
fail unless p(test.baz) == 14

class TestPositionalDescendantMore < TestPositionalDescendant
  attr :z

  def initialize(x, y, z, **options)
    super(x, y, **options)
    @z = z
  end
end

test = TestPositionalDescendantMore.new(1, 2, 3, foo: 42, bar: 21)
fail unless p(test.x) == 1
fail unless p(test.y) == 2
fail unless p(test.z) == 3
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
fail unless p(test.baz) == 14

class TestPositionalDescendantFull < TestPositionalDescendant
  attr :z
  kwattr opt: 42
  kwattr :req

  def initialize(x, y, z, **options)
    super(x, y, **options)
    @z = z
  end
end

test = TestPositionalDescendantFull.new(1, 2, 3, foo: 42, bar: 21, opt: 7, req: 6)
fail unless p(test.x) == 1
fail unless p(test.y) == 2
fail unless p(test.z) == 3
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
fail unless p(test.baz) == 14
fail unless p(test.opt) == 7
fail unless p(test.req) == 6

class TestDefaults
  kwattr foo: 42, bar: 21
end

test = TestDefaults.new
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21

class TestKeywordArgs
  kwattr foo: 42
  attr :bar

  def initialize(bar: 21)
    @bar = bar * 3
  end
end

test = TestKeywordArgs.new(foo: 42, bar: 14)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 42

class TestInit
  kwattr foo: 42, bar: 21

  def initialize
    @inits ||= []
    @inits << 1
  end
end

class TestInitDescendant < TestInit
  kwattr baz: 14
  attr :inits

  def initialize(*)
    super
    @inits << 2
  end
end

test = TestInit.new(bar: 42)
test = TestInitDescendant.new(baz: 7)
fail unless p(test.inits) == [1, 2]

module Foo
  kwattr :foo
end

class TestModule
  include Foo
end

test = TestModule.new(foo: 42)
fail unless p(test.foo) == 42

module Bar
  kwattr :bar
end

class TestModules
  include Foo, Bar
end

test = TestModules.new(foo: 42, bar: 21)
fail unless p(test.foo) == 42
fail unless p(test.bar) == 21
