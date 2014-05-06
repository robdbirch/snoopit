require 'snoopit/version'
require 'snoopit/logger'
require 'snoopit/register'
require 'snoopit/snooper'
require 'snoopit/snoopy'
require 'snoopit/sniffer'
require 'snoopit/detected'
require 'snoopit/notification_manager'
require 'snoopit/notifier'
require 'snoopit/notifiers/email'
require 'snoopit/file_track'

module Snoopit

  def self.logger
    Snoopit::Logger.logger
  end

end
