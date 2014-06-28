module Snoopit

  # Snoops around the specified file or directory of files
  class Snoopy

    attr :name, :input, :output, :dir, :glob, :sniffers

    # This creates a +Snoopy+ which was specified in the +snoopers.json+ file in the +snoopers+ section
    # @param name [String] the name of the snoopy
    # @param params [Hash] this is a hash from the +snoopers.json+ file in the +snoopers+ section for this +Snoopy+
    def initialize(name, params)
      @name = name
      @output = params['output']
      setup_input params
      setup_dir params unless params['dir'].nil?
      input_check?
      setup_sniffers params
    end

    # Get the name of the file to snoop if specified
    # @param params [Hash] this is a hash from the +snoopers.json+ file in the +snoopers+ section for this +Snoopy+
    def setup_input(params)
      @input = params['snoop']
    end

    # Get the name of the directory to snoop if specified
    # @param params [Hash] this is a hash from the +snoopers.json+ file in the +snoopers+ section for this +Snoopy+
    def setup_dir(params)
      @dir = params['dir']['path']
      @glob = params['dir']['glob']
    end

    # Ensure we have something to snoop
    def input_check?
      return true unless @input.nil?
      return true unless @dir.nil?
      raise ArgumentError.new('Snooper JSON must contain either an input or dir parameter')
    end

    # Create the specified sniffers
    # @param params [Hash] this is a hash from the +snoopers.json+ file in the +sniffers+ section for this +Snoopy+
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

    # Sniff specified line which is from the named file
    # param file [String] file +Snoopy+ is sniffing
    # param line_no [Integer] line_n0 +Snoopy+ is sniffing
    # param line [String] line +Snoopy+ is sniffing
    def sniff(file, line_no, line)
      @sniffers.each do |sniffer|
        sniffer.track file, line_no, line
      end
    end

    def as_json(options=nil)
      {
          name: @name,
          input: @input,
          dir: @dir,
          glob: @glob,
          sniffers: @sniffers
      }
    end

    def to_json(*a)
     as_json.to_json(*a)
    end

  end
end