require 'spec_helper'

describe 'Snooper' do

  before(:each) do
    @file    = File.expand_path('../support/sniffers.json', __FILE__)
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


end