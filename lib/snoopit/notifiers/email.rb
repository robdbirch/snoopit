require 'net/smtp'
require 'date'

module Snoopit
  module Notifiers

    class Email < Snoopit::Notifier

      attr :smtp_server, :port, :tls

      def initialize(config=nil)
        super config, 'email'
      end

      def set_config(config)
        super config
        @smtp_server = @config['smtp-server']
        @port        = @config['port']
        @tls         = @config['tls']
        @user        = @config['user']
        @password    = @config['password']
      end

      def notify(found, notifier_params)
        send found, notifier_params['email']
      end

      def send(msg, notifier_params)
        begin
          auth = notifier_params['authentication'].nil? ? :login : notifier_params['authentication'].to_sym
          from = notifier_params['from'].nil? ? 'snoopit@snooper.notifier.com' : notifier_params['from']
          formatted = build_msg from, notifier_params['to'], msg
          smtp = Net::SMTP.new @smtp_server, @port
          smtp.enable_starttls_auto
          smtp.start @user.split('@')[1], @user, @password, auth do |smtp|
            smtp.send_message(formatted, from, notifier_params['to'])
          end
        rescue => e
          Snoopit.logger.warn e.message
          Snoopit.logger.warn e.backtrace
        end
      end

      def build_msg(from, to, msg)
        msg = <<-MSG
From: #{from}
To: #{to.join(', ')}
Content-Type: text/plain
Subject: #{msg[:comment]}
Date: #{DateTime.now.rfc822}

Snooper event on line: #{msg[:match_line_no]} in file: #{msg[:file]}

#{msg[:before].join('')}#{msg[:match]}#{msg[:after].join('')}
MSG
        msg
      end


    end
  end
end