require 'spec_helper'

describe 'HTTP Notifier'  do

  before(:each) do
    @file        = File.expand_path('../../support/snoopies_notifiers.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
    @json_hash['notifiers'].delete 'stomp'
    @json_hash['notifiers'].delete 'https'
    @json_hash['notifiers'].delete 'email'
    @snooper     = Snooper.new false
    @nm          = NotificationManager.new
    @snooper.load_snoopers @json_hash
    @nm.load_notifier_config @json_hash['notifiers']
    @nm.unregister_by_name 'email'
  end

  it 'http stub notify' do
    http = @nm.get_notifier 'http'
    expect(http.name).to eq 'http'
    snoopies = @snooper.snoop
    h = @nm.get_notifier 'http'
    n = h.stub(:notify)
    @nm.notify(snoopies)
  end

  it 'http notify', :skip do
    http = @nm.get_notifier 'http'
    expect(http.name).to eq 'http'
    snoopies = @snooper.snoop
    @nm.notify(snoopies)
  end



end