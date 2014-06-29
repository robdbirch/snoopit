require 'stomp'
require 'awesome_print'

module Snoopit
  # Notifiers belong to this module
  module Notifiers

    class Stomp < Snoopit::Notifier

      # The name 'stomp' is used by the Snooper to identify type of notifier to create
      # The empty constructor is used to initialize the class when loaded dynamically
      # After loaded dynamically the method set_config is called by the base class to set the configuration
      def initialize(config=nil)
        super config, 'stomp'
        @host     = config['host']  || 'localhost'
        @port     = config['port']  || 61613
        @login    = config['login']
        @passcode = config['passcode']
        @headers  = config['headers']
      end

      def get_connection
        params =  { hosts: [ get_connect_params ] }
        set_connect_headers params
        ::Stomp::Connection.new params
      rescue => e
        Snoopit.logger.warn 'Stomp failed to connect: ' + params.to_json
        Snoopit.logger.warn 'Stomp failed to connect: ' + e.message
        Snoopit.logger.warn 'Stomp failed to connect: ' + e.backtrace.join('\n')
        nil
      end

      def get_connect_params
        params            = { host: @host, port: @port }
        params[:login]    = @login unless @login.nil?
        params[:passcode] = @passcode unless @passcode.nil?
        params
      end

      def set_connect_headers(params)
        params[:connect_headers] = @headers unless @headers.nil?
      end

      def notify(found, notify_params)
        conn = get_connection
        send_message(conn, found, notify_params) unless conn.nil?
      rescue => e
          Snoopit.logger.warn e.message
          Snoopit.logger.warn e.backtrace.join('\n')
      ensure
        conn.disconnect unless conn.nil?
      end

      def send_message(conn, found, notify_params)
        conn.publish notify_params['queue'], found.to_json, notify_params['headers']
      end

    end
  end
end