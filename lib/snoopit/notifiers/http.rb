require 'net/http'
require 'net/https'
require 'uri'
require 'awesome_print'

module Snoopit
  module Notifiers

    class Http < Snoopit::Notifier

      def initialize(config=nil)
        super config, 'http'
      end

      # This method is called from the Parent initializer BE SURE to call super
      # use this as an initializer hook to set instance variables specific to this notifier
      def set_config(config)
        super config
        @api_key = config['api-key']
      end

      def notify(found, notify_params)
        raise ArgumentError.new 'URL parameter must be set' if notify_params['url'].nil?
        post_it found, notify_params, URI(notify_params['url'])
      end

      def post_it(found, notify_params, uri)
        conn = get_conn uri
        request = build_request uri, found, notify_params
        post conn, request
      end

      def post(conn, request)
        response = conn.request(request)
        case response.code
          when 200..299, 300..399
            logger.debug 'Posted notification to: ' + response.uri.to_s
            logger.debug.ap found
          when 400..599
            logger.warn 'Failed to send notification to uri: ' + response.uri.to_s
            logger.warn 'Failed to send notification to uri: ' + response.message
        end
      rescue => e
        Snoopit.logger.warn 'Failed to send notification to uri: ' + response.uri.to_s unless response.nil?
        Snoopit.logger.warn 'Failed to send notification to uri: ' + e.message
        Snoopit.logger.warn 'Failed to send notification to uri: ' + e.backtrace.join("\n")
      ensure
        conn.finish if conn.started?
      end

      def build_request(uri, found, notify_params)
        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth notify_params['user'], notify_params['password'] unless notify_params['user'].nil?
        request.body = found.to_json
        set_headers request
        request
      end

      def get_conn(uri)
        case uri.scheme
          when 'http'
            set_http(uri)
          when 'https'
            set_https(uri)
        end
      end

      def set_http(uri)
        Net::HTTP.new uri.host, uri.port
      end

      def set_https(uri)
        conn =  Net::HTTP.new uri.host, uri.port
        conn.use_ssl = true
        conn.verify_mode = OpenSSL::SSL::VERIFY_PEER
        conn
      end

      def set_headers(request)
        request['Content-Type'] = 'application/json'
        request['Authorization'] = 'Token token=' + @api_key unless @api_key.nil?
      end

    end

  end

end