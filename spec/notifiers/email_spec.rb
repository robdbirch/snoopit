require 'spec_helper'

describe 'Email Notifier', :skip do

  before(:each) do
    @file        = File.expand_path('../../support/snoopies_email.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
    @snooper = Snooper.new false
    @snooper.load_snoopers @json_hash
    @nm = NotificationManager.new
    @nm.load_notifier_config @json_hash['notifiers']
  end

  it 'email' do
    emn = @nm.get_notifier 'email'
    expect(emn.name).to eq 'email'
    snoopies = @snooper.snoop
    @nm.notify(snoopies)
  end


end