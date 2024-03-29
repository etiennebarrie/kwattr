require 'spec_helper'
require_relative 'examples'

RSpec.describe KWAttr do
  it 'has a version number' do
    expect(KWAttr::VERSION).not_to be nil
  end

  # ZERO

  shared_examples 'a class with nothing to initialize' do
    it 'can be initialized' do
      described_class.new
    end

    it 'can be initialized with an options hash' do
      described_class.new(**{})
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(err: 43)
    end
  end

  describe OneAttrDefault, 'a class with one kwattr with a default' do
    include_examples 'a class with nothing to initialize'

    example 'attribute with default is initialized' do
      instance = described_class.new
      expect(instance.foo).to eq described_class::DEFAULT_FOO
    end
  end

  describe TwoAttrsDefaults, 'a class with two kwattrs with defaults' do
    include_examples 'a class with nothing to initialize'

    example 'attributes are initialized' do
      instance = described_class.new
      expect(instance.foo).to eq described_class::DEFAULT_FOO
      expect(instance.bar).to eq described_class::DEFAULT_BAR
    end
  end

  # ONE

  shared_examples 'a class with one attribute' do
    example 'attribute is initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.foo).to eq 42
    end
  end

  shared_examples 'a class with one kwattr to initialize' do
    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new
    end

    it_raises_on_missing_keyword :foo, 'with an options hash' do
      described_class.new(**{})
    end
  end

  describe OneAttr, 'a class with one kwattr' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrTwice, 'a class with one kwattr defined twice' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrTwiceTwoLines, 'a class with one kwattr defined twice on two lines' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrMistakenlyRedefinesIt, 'a class that inherits one kwattr and mistakenly redefines it' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'
  end

  describe TwoAttrsOneDefault, 'a class with two kwattrs, one with a default' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'

    example 'attribute with default is initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.bar).to eq described_class::DEFAULT_BAR
    end
  end

  describe ProtectedAttrs, 'can be combined with methods like protected' do
    include_examples 'a class with one kwattr to initialize'

    example 'attributes are initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.pfoo).to eq 42
      expect(instance.pbar).to eq described_class::DEFAULT_BAR
    end
  end

  describe OneAttrInitializeYield, 'a class that yields in initialize' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'

    example 'yields' do
      described_class.new(foo: 42) { @yielded = true }
      expect(@yielded).to be true
    end
  end


  describe OneAttrViaModule, 'a class with one kwattr defined via a module' do
    include_examples 'a class with one attribute'
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrOnePositional, 'a class with one kwattr, one argument on initialize' do
    example 'attributes are initialized' do
      instance = described_class.new(21, foo: 42)
      expect(instance.foo).to eq 42
      expect(instance.bar).to eq 21
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(21, foo: 42, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(21)
    end

    it_raises_on_missing_keyword :foo, 'with an options hash' do
      described_class.new(21, **{})
    end
  end

  # TWO

  shared_examples 'a class with two kwattrs to initialize' do
    example 'attributes are initialized' do
      instance = described_class.new(foo: 42, bar: 21)
      expect(instance.foo).to eq 42
      expect(instance.bar).to eq 21
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(bar: 42)
    end

    it_raises_on_missing_keyword :bar do
      described_class.new(foo: 42)
    end
  end

  shared_examples 'unknown keyword exception' do
    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42, bar: 21, err: 43)
    end
  end

  shared_examples 'wrong number of arguments exception, non-introspectable super' do
    it_raises_wrong_number_of_arguments given: 1, expected: 0 do
      described_class.new(foo: 42, bar: 21, err: 43)
    end
  end

  shared_examples 'combined errors for two keywords' do
    it_raises_on_missing_keywords :foo, :bar do
      described_class.new
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new(**{})
    end
  end

  shared_examples 'incomplete exception for missing keywords, non-introspectable super' do
    it_raises_on_missing_keyword :bar do
      described_class.new
    end

    it_raises_on_missing_keyword :bar, 'with an options hash' do
      described_class.new(**{})
    end
  end

  describe TwoAttrs, 'a class with two kwattrs' do
    include_examples 'a class with two kwattrs to initialize'
    include_examples 'unknown keyword exception'
    include_examples 'combined errors for two keywords'
  end

  describe TwoAttrsOnTwoLines, 'a class with two kwattrs' do
    include_examples 'a class with two kwattrs to initialize'
    include_examples 'unknown keyword exception'
    include_examples 'combined errors for two keywords'
  end

  describe OneAttrOneKeyword, 'a class with one kwattr and one keyword parameter' do
    include_examples 'a class with two kwattrs to initialize'
    include_examples 'unknown keyword exception'
    unless defined?(Rubinius) || RUBY_VERSION < '2.2'
      include_examples 'combined errors for two keywords'
    else
      include_examples 'incomplete exception for missing keywords, non-introspectable super'
    end
  end

  describe OneAttrOneKeywordObscure, 'a class with one kwattr and one non-introspectable keyword parameter' do
    include_examples 'a class with two kwattrs to initialize'
    include_examples 'unknown keyword exception'
    include_examples 'incomplete exception for missing keywords, non-introspectable super'
  end

  describe TwoAttrsInheritsOneAttr, 'a class that inherits one kwattr, defines a new one' do
    include_examples 'a class with two kwattrs to initialize'
    include_examples 'wrong number of arguments exception, non-introspectable super'
    include_examples 'incomplete exception for missing keywords, non-introspectable super'
  end

  # THREE

  describe TwoAttrsOnePos, 'a class with two kwattrs and one positional parameter' do
    example 'attributes are initialized' do
      instance = described_class.new(42, foo: 21 , bar: 14)
      expect(instance.baz).to eq 42
      expect(instance.foo).to eq 21
      expect(instance.bar).to eq 14
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(42, foo: 21, bar: 14, err: 43)
    end

    it_raises_wrong_number_of_arguments given: 0, expected: 1 do
      described_class.new(foo: 42, bar: 21)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(bar: 42, baz: 21)
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new(baz: 42)
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new(42)
    end

    it_raises_on_missing_keywords :foo, :bar, 'with an options hash' do
      described_class.new(42, **{})
    end
  end

  # USED IN INITIALIZE

  describe OneAttrUsedInInitialize, 'a class with one kwattr used in initialize' do
    example '#initialize is called with attributes initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.half_foo).to eq 21
    end
  end

  describe OneAttrInheritsUseInInitialize, 'a class that inherits one kwattr and use it in initialize' do
    example '#initialize is called with attributes initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.half_foo).to eq 21
    end
  end

  describe TwoAttrsInheritsOneAttrUsedInInitialize, 'a class that inherits one kwattr, defines one and use both in initialize' do
    example '#initialize is called with attributes initialized' do
      instance = described_class.new(foo: 42, bar: 21)
      expect(instance.foo_times_bar).to eq 42 * 21
    end
  end

  # MISC

  it 'has just the right line number in backtraces' do
    expect { OneAttrOneKeywordObscure.new bar: 42 }.to raise_error do |exception|
      lib_backtrace = exception.backtrace.grep Regexp.union '/lib/kwattr.rb:'
      expect(lib_backtrace).to contain_exactly a_string_matching('kwattr.rb:42:in ')
    end
  end
end
