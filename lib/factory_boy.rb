require 'factory_boy/version'
require 'factory_boy/exceptions'
require 'factory_boy/factory_instance'

module FactoryBoy
  module_function

  @factories = {}

  class << self; attr_reader :factories; end

  def define(&block)
    instance_eval(&block)
  end

  def factory(class_name, **args, &block)
    klass = args[:class] || constantize_class!(class_name)
    factory_instance = FactoryInstance.new(klass, &block)
    @factories[class_name] = factory_instance
  end

  def constantize_class!(class_name)
    Kernel.const_get(class_name.to_s.capitalize)
  rescue NameError
    raise FactoryBoy::UnknownClassNameError
  end

  def build(factory, **args)
    factory_instance = @factories[factory] || (raise FactoryBoy::UndefinedFactoryError)
    factory_instance.build(args)
  end
end
