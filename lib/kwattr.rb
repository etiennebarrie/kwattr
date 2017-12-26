class KWAttr < Module
  VERSION = "1.0.0"

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
    define_method :initialize do |*args, **kwargs, &block|
      required = required_attrs.dup

      defaults.merge(kwargs).each_pair do |key, value|
        next unless required.delete(key) || defaults.key?(key)
        kwargs.delete(key)
        instance_variable_set iv_cache[key], value
      end

      unless required.empty?
        super_required = []
        initialize = method(:initialize)
        initialize.super_method.parameters.each do |type, name|
          super_required << name if type == :keyreq && !kwargs.key?(name)
        end
        required.unshift(*super_required)
        raise ArgumentError,
          "missing keyword#{'s' if required.size > 1}: #{required.join(', ')}"
      end

      args << kwargs unless kwargs.empty?

      begin


        super(*args, &block)

      rescue ArgumentError
        arity = method(:initialize).super_method.arity
        if !kwargs.empty? && arity != -1 && arity == args.size - 1
          raise ArgumentError,
            "unknown keyword#{'s' if kwargs.size > 1}: #{kwargs.keys.join(', ')}"
        end
        raise
      end
    end
    $VERBOSE = verbose
  end

  def inspect
    "<KWAttr:#{'%#016x'%(object_id<<1)} @required=#{@required.inspect}, @defaults=#{@defaults.inspect}>"
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
