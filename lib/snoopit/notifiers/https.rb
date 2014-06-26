
module Snoopit
  module Notifiers

    class Https < Snoopit::Notifier

      # The name 'https' is used by the Snooper to identify type of notifier to create
      # The empty constructor is used to initialize the class when loaded dynamically
      # After loaded dynamically the method set_config is called by the base class to set the configuration
      def initialize(config=nil)
        super config, 'https'
        @http = Snoopit::Notifiers::Http.new config
      end

      def notify(found, notify_params)
        @http.notify(found, notify_params)
      end

    end
  end
end