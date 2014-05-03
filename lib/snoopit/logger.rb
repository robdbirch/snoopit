require 'logger'
require 'awesome_print'

module Snoopit
  module Logger

    LEVEL_MAP = {
        info: ::Logger::INFO,
        warn: ::Logger::WARN,
        error: ::Logger::ERROR,
        fatal: ::Logger::FATAL,
        debug: ::Logger::DEBUG
    }

    def self.create_logger(out=STDOUT, level=::Logger::INFO)
      @logger = ::Logger.new(out)
      @logger.level = level
      @logger
    end

    def self.logger
      @logger || create_logger
    end

    def logger
      Snoopit::Logging.logger
    end

  end
end