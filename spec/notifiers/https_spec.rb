require 'spec_helper'
require 'awesome_print'

describe 'HTTPS Notifier'  do

  before(:each) do
    @file        = File.expand_path('../../support/snoopies_notifiers.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
    @snooper     = Snooper.new false
    @nm          = NotificationManager.new
    @snooper.load_snoopers @json_hash
    @nm.load_notifier_config @json_hash['notifiers']
    @nm.unregister_by_name 'email'
  end

  it 'http stub notify' do
    http = @nm.get_notifier 'https'
    expect(http.name).to eq 'https'
    snoopies = @snooper.snoop
    h = @nm.get_notifier 'https'
    h.stub(:notify)
    @nm.notify(snoopies)
  end

  it 'http notify', :skip do
    http = @nm.get_notifier 'https'
    expect(http.name).to eq 'https'
    snoopies = @snooper.snoop
    @nm.notify(snoopies)
  end



end