require 'spec_helper'

describe 'Snooper' do

  before(:each) do
    @file    = File.expand_path('../support/snoopies.json', __FILE__)
    @json    = IO.read(@file)
    @jhash   = JSON.parse(@json)
    @jsnoopy = @jhash[0]
    @snooper = Snooper.new
  end

  def test_snooper(snooper)
    snooper.snoopies.size.should eq 1
    snoopy = snooper.snoopies[0]
    snoopy.input.should eq @jsnoopy['input']
    snoopy.dir.should eq @jsnoopy['dir']['path']
    snoopy.suffix.should eq @jsnoopy['dir']['suffix']
    snoopy.input_check?.should == true
  end

  it 'loads a regexp configuration file and validates input and dir via file' do
    @snooper.load_file @file
    test_snooper @snooper
  end

  it 'loads a regexp configuration and validates input and dir via json string' do
    @snooper.load_json @json
    test_snooper @snooper
  end

  it 'loads a regexp configuration and validates input and dir via array of snoopies' do
    @snooper.load_array @jhash
    test_snooper @snooper
  end

  it 'loads a regexp configuration and with invalid input file' do
    expect { @snooper.load_file(nil) }.to raise_error ArgumentError
  end

  it 'loads a regexp configuration and with no snoopies via empty hash' do
    expect { @snooper.load_array([]) }.to raise_error ArgumentError
  end

  it 'loads a regexp configuration and with invalid input and dir via hash' do
    @jsnoopy['input'] = nil
    @jsnoopy['dir']['path'] = nil
    @jsnoopy['dir']['suffix'] = nil
    expect { @snooper.load_array [ @jsnoopy ] }.to raise_error ArgumentError
  end

  it 'loads a snoopies json file and sniffs out a log file containing Non OK Status', :focus do
    @jsnoopy['dir']['path'] = nil
    @jsnoopy['dir']['suffix'] = nil
    @snooper.load_array [ @jsnoopy ]
    Snoopit.logger.level = ::Logger::DEBUG
    tracked = @snooper.snoop
    puts "Number of snoopies with found data: #{tracked.size}"
    tracked.each do |snoopy|
      puts "Number of snoopy sniffers with found data: #{snoopy.sniffers.size}"
      snoopy.sniffers.each do |sniffer|
        puts "Number of snoopy sniffers with sniffed out data: #{sniffer.sniffed.size}"
        sniffer.sniffed.each do |sniffed|
          puts "Matched: #{sniffed.match}"
          puts "File: #{sniffed.file}"
          puts "Line No: #{sniffed.line_no}"
        end
      end
    end

  end

end