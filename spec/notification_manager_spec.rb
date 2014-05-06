require 'spec_helper'

describe 'Notification Manager' do

  before(:each) do
    @file    = File.expand_path('../support/snoopies.json', __FILE__)
    @json    = IO.read(@file)
    @jhash   = JSON.parse(@json)
  end

  context 'Config' do

    def config_check(nm)
      nm.config.should include 'email'
      nm.config['email'].should include 'smtp-server'
      nm.config['email'].should include 'port'
    end

    it 'load valid config on new' do
      nm = NotificationManager.new @jhash['notifiers']
      config_check nm
    end

    it 'load valid config' do
      nm = NotificationManager.new
      nm.load_notifier_config @jhash['notifiers']
      config_check nm
    end

  end

end