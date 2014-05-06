module Snoopit
  module Notifiers
    class Email < Snoopit::Notifier

      def initialize(config)
        @config = config
      end

    end
  end
end