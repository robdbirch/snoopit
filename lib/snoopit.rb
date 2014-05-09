require 'snoopit/version'
require 'snoopit/logger'
require 'snoopit/register'
require 'snoopit/snooper'
require 'snoopit/snoopy'
require 'snoopit/sniffer'
require 'snoopit/detected'
require 'snoopit/file_info'
require 'snoopit/file_tracker'
require 'snoopit/notification_manager'
require 'snoopit/notifier'
require 'snoopit/notifiers/email'


module Snoopit

  def self.logger
    Snoopit::Logger.logger
  end

end
