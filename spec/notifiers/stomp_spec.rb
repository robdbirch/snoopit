require 'spec_helper'

describe 'Stomp Notifier'  do

  before(:each) do
    @file        = File.expand_path('../../support/snoopies_notifiers.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
    @snooper     = Snooper.new false
    @nm          = NotificationManager.new
    @json_hash['notifiers'].delete 'http'
    @json_hash['notifiers'].delete 'https'
    @json_hash['notifiers'].delete 'email'
    @snooper.load_snoopers @json_hash
    @nm.load_notifier_config @json_hash['notifiers']
    @nm.unregister_by_name 'email'
  end

  it 'stomp stub notify' do
    stomp = @nm.get_notifier 'stomp'
    expect(stomp.name).to eq 'stomp'
    snoopies = @snooper.snoop
    h = @nm.get_notifier 'stomp'
    n = h.stub(:notify)
    @nm.notify(snoopies)
  end

  it 'stomp notify', :skip do
    stomp = @nm.get_notifier 'stomp'
    expect(stomp.name).to eq 'stomp'
    snoopies = @snooper.snoop
    @nm.notify(snoopies)
  end
end