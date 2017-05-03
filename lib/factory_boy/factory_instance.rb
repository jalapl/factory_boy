class FactoryInstance
  attr_reader :klass, :defaults

  def initialize(klass, &block)
    @klass = klass
    @defaults = {}
    instance_eval(&block)
  end

  def build(args)
    klass.new.tap do |instance|
      defaults.each do |attribute, default_value|
        value = args[attribute] || default_value
        instance.public_send("#{attribute}=", value)
      end
    end
  end

  def method_missing(method, *args, &block)
    raise FactoryBoy::UnknownClassAttributeError unless klass.method_defined?(method)
    if !block.nil?
      defaults[method] = yield
    else
      defaults[method] = args.first
    end
  end
end
