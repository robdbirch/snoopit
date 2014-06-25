
module Snoopit
  module Notifiers

    class Https < Snoopit::Notifier

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