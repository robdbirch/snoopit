module Snoopit

  # @abstract Subclass
  # Override {#notify} method
  class Notifier

    attr_accessor :name, :configuration, :klass

    # The name is used by the Snooper to identify type of notifier to create
    # @param name [String] name of notifier if the name is nil the class name is used
    # The empty constructor is used to initialize the class when loaded dynamically
    # After loaded dynamically the method set_config is called to set the configuration
    def initialize(config=nil, name=nil, klass=nil)
      @name = name.nil? ? self.class.name : name
      @klass = klass.nil? ? self.class.name : klass
      @config = config
    end

    def notify(found, notify_params)
      raise NotImplementedError.new 'Notifier#notify'
    end

  end

end