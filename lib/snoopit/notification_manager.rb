module Snoopit

  # Instantiates all specified +Notifiers+
  class NotificationManager

    attr :active, :config

    def initialize(config=nil)
      @active = {}
      @config = config
      load_default_notifiers unless @config.nil?
    end

    # Load default notifiers and configured notifiers
    def load_notifier_config(config)
      @config = config
      load_default_notifiers
      load = @config['load']
      load_files(load) unless load.nil?
    end

    # Register the specified +Notifier+
    # @param notifier [Notifier]
    def register(notifier)
      raise NameError.new "Notifier missing valid name: #{notifier.inspect}" if notifier.name.nil?
      Snoopit.logger.debug "Registering notifier #{notifier.name}"
      @active[notifier.name] = notifier
    end

    # Unregister the specified +Notifier+
    # @param notifier [Notifier]
    def unregister(notifier)
      self.unregister_by_name notifier.name
    end

    def unregister_by_name(notifier_name)
      @active.delete notifier_name
    end

    def get_notifier(name)
      @active[name]
    end

    # Invoke all notifications that this list of snoopies is subscribed to via the +snooper.json+
    # @param snoopies [Snoopy]
    def notify(snoopies)
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          sniffer_notify(sniffer)
        end
      end
    end

    # Snoopies use sniffers that may or may not be associated with a notifier
    # @param sniffer [Sniffer]
    def sniffer_notify(sniffer)
      messages = get_sniffed_messages sniffer
      sniffer.notifiers.each do |key, value|
        n = @active[key]
        next if n.nil?
        messages.each do |message|
          n.notify(message, value)
        end
      end
    end

    private

    def load_default_notifiers
      path = File.expand_path('../notifiers', __FILE__)
      Dir.entries(path).each do |file|
        next if File.directory? file
        file_require "#{path}/#{file}"
      end
      create_default_notifiers
    end

    def create_default_notifiers
      Snoopit::Notifiers.constants.select do  |c|
        if Class === Snoopit::Notifiers.const_get(c)
          config = @config[c.to_s.downcase]
          unless config.nil?
            o = Snoopit::Notifiers.const_get(c).new config
            @active[o.name] = o
          else
            Snoopit.logger.debug "Notifier #{c.to_s.downcase} not loaded due to no configuration specified"
          end
        end
      end
    end

    def file_require(file)
      Snoopit.logger.debug "Requiring notifier file: #{file}"
      require file
    end

    def load_files(load)
      load.keys.each do |key|
        entry = load[key]
        next if entry['file'].nil?
        next if entry['class'].nil?
        file_require entry['file']
        create_notifier entry['class'], entry['config']
      end
    end

    def create_notifier(klass, notifier_config=nil)
      o = Object.const_get(klass).new notifier_config
      @active[o.name] = o
    end

    def get_sniffed_messages(sniffer)
      messages = []
      sniffer.sniffed.each do |sniffed|
        messages << build_message(sniffed)
      end
      messages
    end

    def build_message(sniffed)
      {
          comment: sniffed.comment,
          file: sniffed.file,
          before: sniffed.before.register.reverse,
          match: sniffed.match,
          match_line_no: sniffed.line_no,
          after: sniffed.after.register.reverse
      }
    end

  end

end