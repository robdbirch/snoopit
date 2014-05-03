module Snoopit
  class Snoopy

    attr :input, :output, :dir, :glob, :sniffers

    def initialize(params)
      @output = params['output']
      setup_input params
      setup_dir params
      input_check?
      setup_sniffers params
    end

    def setup_input(params)
      @input = params['input']
    end

    def setup_dir(params)
      @dir = params['dir']['path']
      @glob = params['dir']['glob']
    end

    def input_check?
      return true unless @input.nil?
      return true unless @dir.nil?
      raise ArgumentError.new('Snooper JSON must contain either an input or dir parameter')
    end

    def setup_sniffers(params)
      raise ArgumentError.new('Snooper JSON missing sniffers array') if params['sniffers'].nil?
      @sniffers = []
      params['sniffers'].each do |sniffer|
        @sniffers << Sniffer.new(sniffer)
      end
    end

    def dir?
      ! @dir.nil?
    end

    def glob?
      ! @glob.nil?
    end

    def sniff(file, line_no, line)
      @sniffers.each do |sniffer|
        sniffer.track file, line_no, line
      end
    end

    def get_tracked
      tracked = []
      @sniffers.each do |sniffer|
        tracked <<  { snoopy: self } if sniffer.sniffed.size > 0
      end
      tracked
    end

  end
end