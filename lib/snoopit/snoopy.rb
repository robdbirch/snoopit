module Snoopit
  class Snoopy

    attr :input, :output, :dir, :suffix, :sniffers

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
      @suffix = params['dir']['suffix']
    end

    def input_check?
      return true unless @input.nil?
      return true unless @dir.nil?
      raise ArgumentError.new('Snooper JSON must contain either an input or dir parameter')
    end

    def setup_sniffers(params)
      @sniffers = []
      raise ArgumentError.new('Snooper JSON missing sniffers array') if params['sniffers'].nil?
      params['sniffers'].each do |sniffer|
        @sniffers << Sniffer.new(sniffer)
      end
    end

    def dir?
      @dir.nil?
    end

    def suffix?
      @suffix.nil?
    end

    def sniff(line)
      @sniffers.each do |sniffer|
        sniffer.track line
      end

    end

  end
end