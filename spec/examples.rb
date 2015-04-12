class OneAttr
  kwattr :foo
end

class OneAttrTwice
  kwattr :foo, :foo
end

class OneAttrTwiceTwoLines
  kwattr :foo
  kwattr :foo
end

class OneAttrDefault
  DEFAULT_FOO = 42

  kwattr foo: DEFAULT_FOO
end

class OneAttrOneKeyword
  kwattr :foo
  attr_reader :bar

  def initialize(bar:)
    @bar = bar
  end
end

class OneAttrOnePositional
  kwattr :foo
  attr_reader :bar

  def initialize(bar)
    @bar = bar
  end
end

class TwoAttrs
  kwattr :foo, :bar
end

class TwoAttrsOnTwoLines
  kwattr :foo
  kwattr :bar
end

class TwoAttrsDefaults
  DEFAULT_FOO = 42
  DEFAULT_BAR = 21

  kwattr foo: DEFAULT_FOO, bar: DEFAULT_BAR
end

class TwoAttrsOneDefault
  DEFAULT_BAR = 21

  kwattr :foo, bar: DEFAULT_BAR
end

class TwoAttrsOnePos
  kwattr :foo, :bar
  attr_reader :baz

  def initialize(baz)
    @baz = baz
  end
end

class ProtectedAttrs
  DEFAULT_BAR = 21

  protected *kwattr(:foo, bar: DEFAULT_BAR)

  def pfoo
    foo
  end

  def pbar
    bar
  end
end

class TwoAttrsInheritsOneAttr < OneAttr
  kwattr :bar
end

class OneAttrMistakenlyRedefinesIt < OneAttr
  kwattr :foo
end

module OneAttrModule
  kwattr :foo
end

class OneAttrViaModule
  include OneAttrModule
end
