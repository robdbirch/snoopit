require 'snoopit'

class TestNotifierLoad < Snoopit::Notifier

  attr :found, :config, :params

  def initialize(config=nil)
    super config, 'Test Notifier Load'
    @found = []
    @params = nil
  end

  def notify(found, notify_params=nil)
    @found << found
    @params = notify_params
  end

end
