module KWAttr
  VERSION = "0.2.0"

  def kwattr(*attrs, **opts)
    names = [*attrs, *opts.keys]
    attr_reader(*names)
    prepend Initializer
    extend Heritable
    required, defaults = kwattrs
    attrs.each { |attr| required << attr unless required.include?(attr) }
    defaults.merge!(opts)
    names
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
        super_initialize = method(:initialize).super_method
        super_initialize.parameters.each { |type, name| required << name if type == :keyreq && !kwargs.key?(name) }
        raise ArgumentError,
          "missing keyword#{'s' if required.size > 1}: #{required.join(', ')}"
      end
      unless kwargs.empty?
        if method(:initialize).super_method.arity == args.size
          raise ArgumentError,
            "unknown keyword#{'s' if kwargs.size > 1}: #{kwargs.keys.join(', ')}"
        end
        args << kwargs
      end
      super(*args)
    end
  end

end

class Module
  def kwattr(*args)
    extend KWAttr
    kwattr(*args)
  end
end
