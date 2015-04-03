require "kwattr/version"

module KWAttr

  def kwattr(*attrs, **opts)
    attr_reader(*attrs, *opts.keys)
    prepend Initializer
    extend Heritable
    required, defaults = kwattrs
    attrs.each { |attr| required << attr unless required.include?(attr) }
    defaults.merge!(opts)
  end

  def kwattrs
    @kwattrs ||= [[], {}]
  end

  module Heritable
    def inherited(subclass)
      required, defaults = kwattrs
      subclass.kwattr(*required, **defaults)
    end

    alias_method :included, :inherited
  end

  module Initializer
    def initialize(*args, **kwargs)
      required, defaults = self.class.kwattrs
      required = required.dup
      defaults.merge(kwargs).each_pair do |key, value|
        next unless required.delete(key) || defaults.key?(key)
        kwargs.delete(key)
        instance_variable_set "@#{key}", value
      end
      unless required.empty?
        raise ArgumentError,
          "missing keyword#{'s' if required.size > 1}: #{required.join(', ')}"
      end
      if method(:initialize).super_method.arity == args.size && !kwargs.empty?
        raise ArgumentError,
          "unknown keyword#{'s' if kwargs.size > 1}: #{kwargs.keys.join(', ')}"
      end
      args << kwargs unless kwargs.empty?
      super(*args)
    end
  end

end

public def kwattr(*args)
  raise TypeError, "wrong type #{self.class} (expected Module)" unless Module === self
  extend KWAttr
  kwattr(*args)
end
