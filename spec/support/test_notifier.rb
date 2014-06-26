require 'snoopit'

class TestNotifier < Snoopit::Notifier

  attr :found, :params, :config

  def initialize(config=nil)
    super config, 'Test Notifier'
    @found = []
    @params = nil
  end

  def notify(found, notify_params=nil)
    @params = notify_params
    @found << found
  end

end
