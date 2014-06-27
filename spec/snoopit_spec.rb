require 'spec_helper'

describe 'Snoopit' do

  # *** Note ***
  # used :skip on some tests due to captured stdout during coverage showing rvm environment only in the ide,
  def capture_stdout(cmd)
    IO.popen cmd, 'r+' do |pipe|
      pipe.close_write
      output = pipe.read
      pipe.close_read
      output
    end
  end

  def cmd
    lib = File.expand_path '../../lib', __FILE__
    'ruby -I ' +  lib + ' ' + File.expand_path('../../bin/snoopit', __FILE__)
  end

  context 'command line options' do

    it '--help' do
      output = capture_stdout cmd + ' --help'
      expect(output).to match(/Usage: snoopit \[options\]/)
      expect(output).to match(/--help/)
      expect(output).to match(/-h/)
      expect(output).to match(/-v/)
      expect(output).to match(/-verbose/)
    end

    it '-h print help message' do
      output = capture_stdout cmd + ' --help'
      expect(output).to match(/Usage: snoopit \[options\]/)
      expect(output).to match(/--help/)
      expect(output).to match(/-h/)
      expect(output).to match(/-v/)
      expect(output).to match(/-verbose/)
    end

    # use :skip with coverage
    it '-t print a snoopers template to standard out', :skip do
      output = capture_stdout cmd + ' -t'
      jo = JSON.parse output
      notifiers = jo['notifiers']
      expect(notifiers['load'].size).to eq 1
      expect(notifiers['load']['Notifier Identifier']['file']).to eq '/path/to/mynotifier'
      expect(notifiers).to include 'email'
      expect(notifiers).to include 'stomp'
      expect(notifiers).to include 'http'
      expect(notifiers).to include 'https'
    end

    it '--snoopers file.json load specified snoopers file' do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' --snoopers ' + file
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to include 'Non OK Status'
      expect(output).to include 'Total Number of records'
    end

    it '-s file.json load specified snoopers file' do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core\:/
      expect(output).to include 'Non OK Status'
      expect(output).to include 'Total Number of records'
      expect(output).to include 'Failed to bulk load'
    end

    it '-S snooper only use the specified snooper from the snoopers file' do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' -S AppServer2'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
    end

    it '--snooper snooper only user the specified snooper from the snoopers file' do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
    end

    # use :skip with coverage
    it '--json generate json output', :skip do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 --json'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      jo = JSON.parse output
      expect(jo.size).to eq 1
      app2 = jo[0]
      expect(app2['name']).to eq 'AppServer2'
      sniffers = app2['sniffers'][0]
      expect(sniffers['before']).to eq 2
      expect(sniffers['after']).to eq 2
      sniffed = sniffers['sniffed']
      expect(sniffed.size).to eq 120
    end

    # use :skip with coverage
    it '-j generate json output', :skip do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 -j'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      jo = JSON.parse output
      expect(jo.size).to eq 1
      app2 = jo[0]
      expect(app2['name']).to eq 'AppServer2'
      sniffers = app2['sniffers'][0]
      expect(sniffers['before']).to eq 2
      expect(sniffers['after']).to eq 2
      sniffed = sniffers['sniffed']
      expect(sniffed.size).to eq 120
    end

    # use :skip with coverage
    it '2 snoopers', :skip do
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' -S AppServer2  -S SnoopTest -j'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to include 'Non OK Status'
      expect(output).to include 'Total Number of records'
      expect(output).to include 'Failed to bulk load'
      jo = JSON.parse output
      expect(jo.size).to eq 2
      app = jo[0]
      names = []
      names << app['name']
      sniffers = app['sniffers'][0]
      expect(sniffers['before']).to eq 2
      expect(sniffers['after']).to eq 2
      sniffed = sniffers['sniffed']
      expect(sniffed.size).to eq 120
      app2 = jo[1]
      names << app2['name']
      expect(names.size).to eq 2
      expect(names).to include 'SnoopTest'
      expect(names).to include 'AppServer2'
      sniffers = app2['sniffers'][0]
      expect(sniffers['before']).to eq 2
      expect(sniffers['after']).to eq 2
      sniffed = sniffers['sniffed']
      expect(sniffed.size).to eq 120
    end

    it '-T enable file tracking' do
      db_file = File.expand_path '../../snoopit_db.json', __FILE__
      File.delete db_file if File.exist? db_file
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 -T'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      expect(File.exist?(db_file)).to eq true
      expect(File.size(db_file)).to be > 0
      tracked = File.read db_file
      expect(tracked).to include './spec/support/log/snoop_log.test'
      expect(tracked).to include './spec/support/log/snoop_log_2.test'
      #ap JSON.parse tracked
      File.delete db_file if File.exist? db_file
    end

    it '--tracking enable file tracking' do
      db_file = File.expand_path '../../snoopit_db.json', __FILE__
      File.delete db_file if File.exist? db_file
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 --tracking'
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      expect(File.exist?(db_file)).to eq true
      expect(File.size(db_file)).to be > 0
      tracked = File.read db_file
      expect(tracked).to include './spec/support/log/snoop_log.test'
      expect(tracked).to include './spec/support/log/snoop_log_2.test'
      #ap JSON.parse tracked
      File.delete db_file if File.exist? db_file
    end

    it '-f filename use a different named tracking file' do
      db_file = File.expand_path '../../tmp/snoopit_db.json', __FILE__
      File.delete db_file if File.exist? db_file
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 -f ' + db_file
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      expect(File.exist?(db_file)).to eq true
      expect(File.size(db_file)).to be > 0
      tracked = File.read db_file
      expect(tracked).to include './spec/support/log/snoop_log.test'
      expect(tracked).to include './spec/support/log/snoop_log_2.test'
      #ap JSON.parse tracked
      File.delete db_file if File.exist? db_file
    end

    it '--tracking-file filename use a different named tracking file' do
      db_file = File.expand_path '../../tmp/snoopit_db.json', __FILE__
      File.delete db_file if File.exist? db_file
      file = File.expand_path '../support/snoopies.json', __FILE__
      output = capture_stdout cmd + ' -s ' + file + ' --snooper AppServer2 --tracking-file ' + db_file
      expect(output).to match /Reading from queue: scores\:\/queue\/scores/
      expect(output).to match /Prediction loader waiting for scores \.\.\./
      expect(output).to match /Non OK Status from AI Core:/
      expect(output).to include 'Non OK Status'
      expect(output).not_to include 'Total Number of records'
      expect(output).not_to include 'Failed to bulk load'
      expect(File.exist?(db_file)).to eq true
      expect(File.size(db_file)).to be > 0
      tracked = File.read db_file
      expect(tracked).to include './spec/support/log/snoop_log.test'
      expect(tracked).to include './spec/support/log/snoop_log_2.test'
      #ap JSON.parse tracked
      File.delete db_file if File.exist? db_file
    end

  end


end