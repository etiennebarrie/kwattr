require 'spec_helper'
require_relative 'examples'

RSpec.describe KWattr do
  it 'has a version number' do
    expect(KWattr::VERSION).not_to be nil
  end

  shared_examples 'a class with nothing to initialize' do
    it 'can be initialized' do
      described_class.new
    end

    it 'can be initialized with an options hash' do
      described_class.new({})
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

  shared_examples 'a class with one kwattr to initialize' do
    example 'attributes are initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.foo).to eq 42
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new
    end

    it_raises_on_missing_keyword :foo, 'with an options hash' do
      described_class.new({})
    end
  end

  describe OneAttr, 'a class with one kwattr' do
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrTwice, 'a class with one kwattr' do
    include_examples 'a class with one kwattr to initialize'
  end

  describe OneAttrMistakenlyRedefinesIt, 'a class that inherits one kwattr and mistakenly redefines it' do
    include_examples 'a class with one kwattr to initialize'
  end

  describe TwoAttrsOneDefault, 'a class with two kwattrs, one with a default' do
    include_examples 'a class with one kwattr to initialize'

    example 'attribute with default is initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.bar).to eq described_class::DEFAULT_BAR
    end
  end

  shared_examples 'a class with two kwattrs to initialize' do
    example 'attributes are initialized' do
      instance = described_class.new(foo: 42, bar: 21)
      expect(instance.foo).to eq 42
      expect(instance.bar).to eq 21
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42, bar: 21, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(bar: 42)
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new
    end

    it_raises_on_missing_keywords :foo, :bar, 'with an options hash' do
      described_class.new({})
    end
  end

  describe TwoAttrs, 'a class with two kwattrs' do
    include_examples 'a class with two kwattrs to initialize'
  end

  describe TwoAttrsOnTwoLines, 'a class with two kwattrs' do
    include_examples 'a class with two kwattrs to initialize'
  end

  describe OneAttrOneKeyword, 'a class with one kwattr and one keyword parameter' do
    include_examples 'a class with two kwattrs to initialize'
  end

  describe TwoAttrsInheritsOneAttr, 'a class that inherits one kwattr, defines a new one' do
    include_examples 'a class with two kwattrs to initialize'
  end

  describe TwoAttrsDefaults, 'a class with two kwattrs with defaults' do
    example 'attributes are initialized' do
      instance = described_class.new
      expect(instance.foo).to eq described_class::DEFAULT_FOO
      expect(instance.bar).to eq described_class::DEFAULT_BAR
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(err: 43)
    end
  end

  describe TwoAttrsOneKeyword, 'a class with two kwattrs and one keyword parameter' do
    example 'attributes are initialized' do
      instance = described_class.new(foo: 42 , bar: 21, baz: 14)
      expect(instance.foo).to eq 42
      expect(instance.bar).to eq 21
      expect(instance.baz).to eq 14
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42 , bar: 21, baz: 14, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(bar: 42, baz: 21)
    end

    it_raises_on_missing_keyword :baz, 'from initialize' do
      described_class.new(foo: 42, bar: 21)
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new(baz: 42)
    end

    it_raises_on_missing_keywords :foo, :bar, 'without an options hash' do
      described_class.new
    end

    it_raises_on_missing_keywords :foo, :baz do
      described_class.new(bar: 42)
    end
  end

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

    it_raises_on_missing_positional_argument do
      described_class.new(foo: 42, bar: 21)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new(bar: 42, baz: 21)
    end

    it_raises_on_missing_keywords :foo, :bar do
      described_class.new(baz: 42)
    end

    it_raises_on_missing_keywords :foo, :bar, 'without an options hash' do
      described_class.new
    end
  end

  describe ProtectedAttrs, 'can be combined with methods like protected' do
    example 'attributes are initialized' do
      instance = described_class.new(foo: 42)
      expect(instance.pfoo).to eq 42
      expect(instance.pbar).to eq described_class::DEFAULT_BAR
    end

    it_raises_on_unknown_keyword :err do
      described_class.new(foo: 42, err: 43)
    end

    it_raises_on_missing_keyword :foo do
      described_class.new
    end
  end
end
