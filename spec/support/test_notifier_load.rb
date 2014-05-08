require 'snoopit'

class TestNotifierLoad < Snoopit::Notifier

  attr :found

  def initialize
    super nil, 'Test Notifier Load'
    @found = []
  end

  def notify(found, notify_params=nil)
    @found << found
  end

end
