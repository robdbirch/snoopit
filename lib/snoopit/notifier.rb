module Snoopit

  # @abstract Subclass
  # Override {#notify} method
  class Notifier

    attr_accessor :name, :configuration

    # The name is used by the Snooper to identify type of notifier to create
    # @param name [String] name of notifier if the name is nil the
    def initialize(name=nil)
      @name = name.nil? ? self.class.name : name
    end

    # This is a json configuration from the <code>snoopers.json</code> notifiers
    def set_config(configuration)
      @configuration = configuration
    end

    # @param file [String] path to configuration file
    def config_file(file)

    end

    def notify(found)
      raise NotImplementedError.new 'Notifier#notify'
    end

  end

end