require 'snoopit/version'
require 'snoopit/logger'
require 'snoopit/register'
require 'snoopit/snooper'
require 'snoopit/snoopy'
require 'snoopit/sniffer'
require 'snoopit/detected'

module Snoopit

  def self.logger
    Snoopit::Logger.logger
  end

end
