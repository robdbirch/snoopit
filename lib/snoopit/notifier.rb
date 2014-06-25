module Snoopit

  # @abstract Subclass
  # Override {#notify} method
  class Notifier

    attr_accessor :name, :configuration, :klass

    # The name is used by the Snooper to identify type of notifier to create
    # @param name [String] name of notifier if the name is nil the class name is used
    def initialize(config=nil, name=nil, klass=nil)
      @name = name.nil? ? self.class.name : name
      @klass = klass.nil? ? self.class.name : klass
      set_config(config) unless config.nil?
    end

    # This is a json configuration from the <code>snoopers.json</code> notifiers
    def set_config(config)
      @config = config
    end

    def notify(found, notify_params)
      raise NotImplementedError.new 'Notifier#notify'
    end

  end

end