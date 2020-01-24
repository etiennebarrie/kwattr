class OneAttr
  kwattr :foo
end

verbose, $VERBOSE = $VERBOSE, false

class OneAttrTwice
  kwattr :foo, :foo
end

class OneAttrTwiceTwoLines
  kwattr :foo
  kwattr :foo
end

$VERBOSE = verbose

class OneAttrDefault
  DEFAULT_FOO = 42

  kwattr foo: DEFAULT_FOO
end

class OneAttrOneKeyword
  kwattr :bar
  attr_reader :foo

  def initialize(foo:)
    @foo = foo
  end
end

class OneAttrOneKeywordObscure
  kwattr :bar
  attr_reader :foo

  # respects exceptions, but can't be introspected because of *args
  def initialize(*args)
    kwargs = args.last or raise ArgumentError, "missing keyword: #{KWAttr.keywords_for_error([:foo]).first}"
    @foo = kwargs.delete(:foo) { raise ArgumentError, "missing keyword: #{KWAttr.keywords_for_error([:foo]).first}" }
    raise ArgumentError, "unknown keyword: #{KWAttr.keywords_for_error(kwargs.keys).first}" if kwargs.one?
    raise ArgumentError, "unknown keywords: #{KWAttr.keywords_for_error(kwargs.keys)}" unless kwargs.empty?
  end
end

class OneAttrInitializeYield
  kwattr :foo

  def initialize
    yield if block_given?
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

  protected(*kwattr(:foo, bar: DEFAULT_BAR))

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

  def initialize
    super(foo: foo)
  end
end

module OneAttrModule
  kwattr :foo
end

class OneAttrViaModule
  include OneAttrModule
end

class OneAttrUsedInInitialize
  kwattr :foo
  attr_reader :half_foo

  def initialize
    @half_foo = foo / 2
  end
end

class OneAttrInheritsUseInInitialize < OneAttr
  attr_reader :half_foo

  def initialize(*)
    super
    @half_foo = foo / 2
  end
end

class TwoAttrsInheritsOneAttrUsedInInitialize < OneAttr
  kwattr :bar
  attr_reader :foo_times_bar

  def initialize(*)
    super
    @foo_times_bar = foo * bar
  end
end
