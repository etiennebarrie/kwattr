class KWAttr < Module
  VERSION = "0.3.0"

  def initialize
    @required = []
    @defaults = {}
  end

  def initializer(attrs, opts)
    required_attrs = @required
    defaults = @defaults
    required_attrs.concat(attrs).uniq!
    defaults.merge!(opts)
    iv_cache = Hash.new { |h, k| h[k] = :"@#{k}" }

    verbose, $VERBOSE = $VERBOSE, false
    define_method :initialize do |*args, **kwargs|
      required = required_attrs.dup

      defaults.merge(kwargs).each_pair do |key, value|
        next unless required.delete(key) || defaults.key?(key)
        kwargs.delete(key)
        instance_variable_set iv_cache[key], value
      end

      unless required.empty?
        method(:initialize).super_method.parameters.each do |type, name|
          required << name if type == :keyreq && !kwargs.key?(name)
        end
        raise ArgumentError,
          "missing keyword#{'s' if required.size > 1}: #{required.join(', ')}"
      end
      unless kwargs.empty?
        arity = method(:initialize).super_method.arity
        if arity != -1 && arity == args.size
          raise ArgumentError,
            "unknown keyword#{'s' if kwargs.size > 1}: #{kwargs.keys.join(', ')}"
        end
        args << kwargs
      end

      super(*args)
    end
    $VERBOSE = verbose
  end
end

class Module
  def kwattr(*attrs, **opts)
    names = [*attrs, *opts.keys]
    attr_reader(*names)
    prepend @kwattrs ||= KWAttr.new
    @kwattrs.initializer(attrs, opts)
    names
  end
end
