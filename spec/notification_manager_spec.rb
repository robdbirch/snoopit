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
      @tn = TestNotifier.new
      @nm.register @tn
      @snooper = Snooper.new false
      @snooper.load_file File.expand_path('../support/snoopies.json', __FILE__)
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
      Snoopit.logger.level = ::Logger::DEBUG
      snoopies = @snooper.snoop
      @nm.notify snoopies
      expect(@tn.found.size).to eq 216
    end


  end

end