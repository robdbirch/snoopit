require 'spec_helper'

describe 'Email Notifier'  do

  before(:each) do
    @file        = File.expand_path('../../support/snoopies_notifiers.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
    @snooper     = Snooper.new false
    @nm          = NotificationManager.new
    @snooper.load_snoopers @json_hash
    @nm.load_notifier_config @json_hash['notifiers']
    @nm.unregister_by_name 'http'
  end

  it 'email stub' do
    emn = @nm.get_notifier 'email'
    expect(emn.name).to eq 'email'
    snoopies = @snooper.snoop
    e = @nm.get_notifier 'email'
    e.stub(:notify)
    @nm.notify(snoopies)
  end

  it 'email', :skip do
    emn = @nm.get_notifier 'email'
    expect(emn.name).to eq 'email'
    snoopies = @snooper.snoop
    @nm.notify(snoopies)
  end


end