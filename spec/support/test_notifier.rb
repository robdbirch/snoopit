require 'snoopit'

class TestNotifier < Snoopit::Notifier

  attr :found

  def initialize
    super nil, 'Test Notifier'
    @found = []
  end

  def notify(found, notify_params=nil)
    @found << found
  end

end
