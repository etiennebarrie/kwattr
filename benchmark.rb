require 'benchmark/ips'
require 'kwattr'
require_relative 'spec/examples'

class ROneAttr
  attr_reader :foo

  def initialize(foo:)
    @foo = foo
  end
end

class ROneAttrDefault
  DEFAULT_FOO = 42

  attr_reader :foo

  def initialize(foo: DEFAULT_FOO)
    @foo = foo
  end
end

class ROneAttrOnePositional
  attr_reader :foo, :bar

  def initialize(bar, foo:)
    @foo = foo
    @bar = bar
  end
end

class RTwoAttrs
  attr_reader :foo, :bar

  def initialize(foo:, bar:)
    @foo = foo
    @bar = bar
  end
end

class RTwoAttrsDefaults
  DEFAULT_FOO = 42
  DEFAULT_BAR = 21

  attr_reader :foo, :bar

  def initialize(foo: DEFAULT_FOO, bar: DEFAULT_BAR)
    @foo = foo
    @bar = bar
  end
end

class RTwoAttrsOneDefault
  DEFAULT_BAR = 21

  attr_reader :foo, :bar

  def initialize(foo:, bar: DEFAULT_BAR)
    @foo = foo
    @bar = bar
  end
end

class RTwoAttrsOnePos
  attr_reader :foo, :bar, :baz

  def initialize(baz, foo:, bar:)
    @foo = foo
    @bar = bar
    @baz = baz
  end
end

class RTwoAttrsInheritsOneAttr < ROneAttr
  attr_reader :bar

  def initialize(foo:, bar:)
    super(foo: foo)
    @bar = bar
  end
end

module ROneAttrModule
  attr_reader :foo

  def initialize(foo:)
    @foo = foo
  end
end

class ROneAttrViaModule
  include ROneAttrModule
end

Benchmark.ips do |b|
  b.warmup = 0.1
  b.time = 1

  b.report "KWAttr classes" do
    OneAttr.new foo: 42
    OneAttrDefault.new
    OneAttrOnePositional.new 42, foo: 21
    TwoAttrs.new foo: 42, bar: 21
    TwoAttrsDefaults.new
    TwoAttrsOneDefault.new foo: 42
    TwoAttrsOnePos.new 42, foo: 21, bar: 14
    TwoAttrsInheritsOneAttr.new foo: 42, bar: 21
    OneAttrViaModule.new foo: 42
  end

  b.report "Plain classes" do
    ROneAttr.new foo: 42
    ROneAttrDefault.new
    ROneAttrOnePositional.new 42, foo: 21
    RTwoAttrs.new foo: 42, bar: 21
    RTwoAttrsDefaults.new
    RTwoAttrsOneDefault.new foo: 42
    RTwoAttrsOnePos.new 42, foo: 21, bar: 14
    RTwoAttrsInheritsOneAttr.new foo: 42, bar: 21
    ROneAttrViaModule.new foo: 42
  end

  b.compare!
end
