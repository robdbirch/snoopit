require 'spec_helper'

describe 'Snooper' do

  before(:each) do
    @file    = File.expand_path('../support/snoopies.json', __FILE__)
    @json    = IO.read(@file)
    @jhash   = JSON.parse(@json)
    @jsnoopy = @jhash['snoopers'][0]
    @snooper = Snooper.new
  end

  def test_snooper(snooper)
    snooper.snoopies.size.should eq 1
    snoopy = snooper.snoopies[0]
    snoopy.input.should eq @jsnoopy['snoop']
    snoopy.dir.should eq @jsnoopy['dir']['path']
    snoopy.glob.should eq @jsnoopy['dir']['glob']
    snoopy.input_check?.should == true
  end

  context 'snooper initialization' do

    it 'loads a regexp configuration file and validates input and dir via file' do
      @snooper.load_file @file
      test_snooper @snooper
    end

    it 'loads a regexp configuration and validates input and dir via json string' do
      @snooper.load_json @json
      test_snooper @snooper
    end

    it 'loads a regexp configuration and validates input and dir via array of snoopies' do
      @snooper.load_snoopers @jhash
      test_snooper @snooper
    end

    it 'loads a regexp configuration and with invalid input file' do
      expect { @snooper.load_file(nil) }.to raise_error ArgumentError
    end

    it 'loads a regexp configuration and with no snoopies via empty hash' do
      expect { @snooper.load_snoopers ({ 'snoopers' => [] }) }.to raise_error ArgumentError
    end

  end

  context 'file tests' do

    before(:each) do
      @jsnoopy['dir'] = nil
    end

    it 'loads a regexp configuration and with invalid input and dir via hash' do
      @jsnoopy['snoop'] = nil
      expect { @snooper.load_snoopers  @jhash }.to raise_error ArgumentError
    end

    it 'loads a snoopies json file and sniffs out a log file' do
      @snooper.load_snoopers  @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 60
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 1
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 47
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 1
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end

    it 'loads a snoopies json file and sniffs out a log file zero before zero after' do
      @jsnoopy['sniffers'].each do |sniffer|
        sniffer['lines']['before'] = 0
        sniffer['lines']['after'] = 0
      end
      @snooper.load_snoopers  @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 60
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 0
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 1
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 0
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 47
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 0
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end


    it 'loads a snoopies json file and sniffs out a log file 0 before 1 after' do
      @jsnoopy['sniffers'].each do |sniffer|
        sniffer['lines']['before'] = 0
        sniffer['lines']['after'] = 1
      end
      @snooper.load_snoopers  @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 60
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 1
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 1
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 1
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 47
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 0
              sniffed.after.size.should eq 1
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end


    it 'loads a snoopies json file and sniffs out a log file 1 before 0 after' do
      @jsnoopy['sniffers'].each do |sniffer|
        sniffer['lines']['before'] = 1
        sniffer['lines']['after'] = 0
      end
      @snooper.load_snoopers  @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 60
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 0
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 1
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 0
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 47
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 0
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end

    it 'Dump trace'  do
      #dump_it
    end

    def dump_it
      @snooper.load_snoopers  [ @jsnoopy ]
      #Snoopit.logger.level = ::Logger::DEBUG
      tracked = @snooper.snoop
      puts "Number of snoopies with found data: #{tracked.size}"
      tracked.each do |snoopy|
        puts "Number of snoopy sniffers with found data: #{snoopy.sniffers.size}"
        snoopy.sniffers.each do |sniffer|
          puts "Number of snoopy sniffers with sniffed out data: #{sniffer.sniffed.size}"
          sniffer.sniffed.each do |sniffed|
            puts ''
            sniffed.before.register.each {|b| puts "Before: #{b}" unless b.nil? }
            puts "Matched: #{sniffed.match}"
            sniffed.after.register.each {|a| puts "After: #{a}" unless a.nil? }
            puts "Before register size: #{sniffed.before.register.size}"
            puts "After register size: #{sniffed.after.register.size}"
            puts "File: #{sniffed.file}"
            puts "Line No: #{sniffed.line_no}"
            puts ''
          end
        end
      end
    end
  end

  context 'directory testing' do

    before(:each) do
      #Snoopit.logger.level = ::Logger::DEBUG
    end

    it 'loads a snoopies json file and sniffs out a directory' do
      @jsnoopy['dir']['glob'] = nil
      @snooper.load_snoopers @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 120
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 2
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 94
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 1
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end

    it 'loads a snoopies json file and sniffs out a glob directory' do
      @snooper.load_snoopers @jhash
      @snooper.snoopies.size.should == 1
      @snooper.snoopies[0].sniffers.size.should == 3
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          if sniffer.regexp.source == 'Non OK Status'
            sniffer.sniffed.size.should eq 120
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Failed to bulk load'
            sniffer.sniffed.size.should eq 2
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 2
              sniffed.after.size.should eq 2
            end
          elsif sniffer.regexp.source == 'Total Number of records:'
            sniffer.sniffed.size.should eq 94
            sniffer.sniffed.each do |sniffed|
              sniffed.before.size.should eq 1
              sniffed.after.size.should eq 1
            end
          else
            # This should not happen
            true.should eq false
          end
        end
      end
    end
  end

  context 'notifiers' do

    it 'check notifiers' do
      @snooper.load_snoopers @jhash
      snoopies = @snooper.snoop
      snoopies.each do |snoopy|
        snoopy.sniffers.each do |sniffer|
          sniffer.notifiers.size.should eq 1 unless sniffer.notifiers.nil?
          sniffer.notifiers.each do |notifier|
            next if notifier.nil?
            if sniffer.comment.include? 'Failed Bulk load'
              expect(notifier).to include 'Test Notifier'
            else
              expect (notifier).should include 'Test Notifier'
            end
          end
        end
      end
    end

  end


end