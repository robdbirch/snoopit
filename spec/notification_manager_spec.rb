require 'spec_helper'

describe 'Notification Manager' do

  before(:each) do
    @file        = File.expand_path('../support/snoopies.json', __FILE__)
    @json        = IO.read(@file)
    @json_hash   = JSON.parse(@json)
  end

  context 'Config' do

    def config_check(nm)
      nm.config.should include 'email'
      nm.config['email'].should include 'smtp-server'
      nm.config['email'].should include 'port'
    end

    it 'load valid config on new' do
      nm = NotificationManager.new @json_hash['notifiers']
      config_check nm
    end

    it 'load valid config' do
      nm = NotificationManager.new
      nm.load_notifier_config @json_hash['notifiers']
      config_check nm
    end

    it 'loads email notifier' do
      nm = NotificationManager.new
      nm.load_notifier_config @json_hash['notifiers']
      nm.active.should include 'email'
      email = nm.active['email']
      email.smtp_server.should eq 'smtp.gmail.com'
      email.port.should eq 587
    end

  end

  context 'Notifiers' do

    before(:each) do
      @nm = NotificationManager.new
      @nm.load_notifier_config @json_hash['notifiers']
      @snooper = Snooper.new false
      @snooper.load_file File.expand_path('../support/snoopies.json', __FILE__)
      @tn = TestNotifier.new
      @nm.register @tn
    end

    it 'unregister notifier' do
      n = @nm.unregister @tn
      expect(n).to eq @tn
      nn = @nm.get_notifier @tn.name
      expect(nn).to be nil
      nnn = @nm.unregister @tn
      expect(nnn).to be nil
    end

    it 'get notifier' do
      n = @nm.get_notifier @tn.name
      expect(n).to eq @tn
    end

    it 'receives messages' do
      #Snoopit.logger.level = ::Logger::DEBUG
      snoopies = @snooper.snoop
      @nm.notify snoopies
      expect(@tn.config).to eq nil
      expect(@tn.params['param1']).to eq 'value1'
      expect(@tn.params['param2']).to eq 'value2'
      expect(@tn.found.size).to eq 122
    end

  end

  context 'Config load Notifiers' do

    before(:each) do
      #Snoopit.logger.level = ::Logger::DEBUG
      @nm = NotificationManager.new
      @nm.load_notifier_config @json_hash['notifiers']
      @snooper = Snooper.new false
      @notifier_name ='Test Notifier Load'
      @snooper.load_snoopers @json_hash
    end

    it 'load notifier from snoopies.json config load section' do
      expect(@nm.active).to include @notifier_name
      snoopies = @snooper.snoop
      @nm.notify snoopies
      tnl = @nm.get_notifier @notifier_name
      expect(tnl.config['c_param1']).to eq 'value1'
      expect(tnl.config['c_param2']).to eq 'value2'
      expect(tnl.params['param1']).to eq 'value1'
      expect(tnl.params['param2']).to eq 'value2'
      expect(tnl.found.size).to eq 94
    end

  end

end