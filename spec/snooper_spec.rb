require 'spec_helper'

describe 'Snooper' do

  context 'base functionality'  do

    before(:each) do
      Snoopit.logger.level = ::Logger::DEBUG
      @file    = File.expand_path('../support/snoopies.json', __FILE__)
      @json    = IO.read(@file)
      @jhash   = JSON.parse(@json)
      @jsnoopy = @jhash['snoopers']['SnoopTest']
      @jsnoopy2 = @jhash['snoopers']['AppServer2']
      @snooper = Snooper.new
    end

    def test_snooper(snooper)
      snooper.snoopies.size.should eq 2
      snoopy = snooper.snoopies['SnoopTest']
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
        @jsnoopy2['dir'] = nil
      end

      it 'loads a regexp configuration and with invalid input and dir via hash' do
        @jsnoopy['snoop'] = nil
        expect { @snooper.load_snoopers  @jhash }.to raise_error ArgumentError
      end

      it 'loads a snoopies json file and sniffs out a log file' do
        #Snoopit.logger.level = ::Logger::DEBUG
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
        @snooper.snoopies['AppServer2'].sniffers.size.should == 1
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
        @jsnoopy2['sniffers'].each do |sniffer|
          sniffer['lines']['before'] = 0
          sniffer['lines']['after'] = 0
        end
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
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
        @jsnoopy2['sniffers'].each do |sniffer|
          sniffer['lines']['before'] = 0
          sniffer['lines']['after'] = 1
        end
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
        @snooper.snoopies['AppServer2'].sniffers.size.should == 1
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
        @jsnoopy2['sniffers'].each do |sniffer|
          sniffer['lines']['before'] = 1
          sniffer['lines']['after'] = 0
        end
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
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
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
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
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 3
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
            sniffer.notifiers.size.should eq 1 unless sniffer.notifiers.size == 0
            sniffer.notifiers.each do |notifier|
              next if notifier.nil?
              if sniffer.comment.include? 'Data gathered to generate a statistics report'
                expect(notifier).to include 'Test Notifier Load'
              else
                expect(notifier).to include 'Test Notifier'
              end
            end
          end
        end
      end
    end
  end


  context 'multiple snoopers' do

      before(:each) do
        @file    = File.expand_path('../support/multiple_snoopies.json', __FILE__)
        @json    = IO.read(@file)
        @jhash   = JSON.parse(@json)
        @jsnoopy = @jhash['snoopers']
        @snooper = Snooper.new
      end

    it 'loads a snoopies json file and sniffs out a log file' do
      @jhash['snoopers'].each do |key, snoop|
        snoop['dir'] = nil
      end
      @snooper.load_snoopers  @jhash
      @snooper.snoopies.size.should == 2
      @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
      @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
      snoopies = @snooper.snoop
      @snooper.snoopies.size.should == 2
      @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
      @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
      process_snoopies = []
      snoopies.each do |snoopy|
        process_snoopies << snoopy.name
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
      expect(process_snoopies).to include 'SnoopTest'
      expect(process_snoopies).to include 'SnoopTest2'
    end


      it 'loads a snoopies json file and sniffs out a directory of log files' do
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
        @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
        snoopies = @snooper.snoop
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
        @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
        process_snoopies = []
        snoopies.each do |snoopy|
          process_snoopies << snoopy.name
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
        expect(process_snoopies).to include 'SnoopTest'
        expect(process_snoopies).to include 'SnoopTest2'
      end


      it 'loads a snoopies json file and sniffs out a log file with a specified 1 snooper' do
        @jhash['snoopers'].each do |key, snoop|
          snoop['dir'] = nil
        end
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
        @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
        snoopies = @snooper.snoop ['SnoopTest']
        snoopies.size.should == 1
        snoopies[0].sniffers.size.should == 2
        process_snoopies = []
        snoopies.each do |snoopy|
          process_snoopies << snoopy.name
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
        expect(process_snoopies).to include 'SnoopTest'
        expect(process_snoopies).not_to include 'SnoopTest2'
      end

      it 'loads a snoopies json file and sniffs out a log file with 2 specified snoopers' do
        @jhash['snoopers'].each do |key, snoop|
          snoop['dir'] = nil
        end
        @snooper.load_snoopers  @jhash
        @snooper.snoopies.size.should == 2
        @snooper.snoopies['SnoopTest'].sniffers.size.should == 2
        @snooper.snoopies['SnoopTest2'].sniffers.size.should == 1
        snoopies = @snooper.snoop ['SnoopTest', 'SnoopTest2']
        snoopies.size.should == 2
        process_snoopies = []
        snoopies.each do |snoopy|
          process_snoopies << snoopy.name
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
        expect(process_snoopies).to include 'SnoopTest'
        expect(process_snoopies).to include 'SnoopTest2'
    end

  end


end