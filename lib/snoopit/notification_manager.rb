module Snoopit

  class NotificationManager

    attr :active, :available, :config

    def initialize(config=nil)
      @config = config.nil? ? [] : config
      load_default_notifiers
      load_available_notifiers
      @active = []
    end

    def load_notifier_config(config)
      @config = config
    end

    def load_available_notifiers
      @available = Snoopit::Notifiers.constants.select { |c| Class === Snoopit::Notifiers.const_get(c) }
    end

    private

    def load_default_notifiers
      path = File.expand_path('../notifiers', __FILE__)
      Dir.entries(path).each do |file|
        next if File.directory? file
        require "#{path}/#{file}"
      end
    end

    def notify(snoopies)
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          msg = build_notification sniffer
        end
      end

    end

    private

    def build_notification(snoopy)
      {
          file: snoopy.input,

      }
    end

  end

end