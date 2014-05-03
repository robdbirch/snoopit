require 'json'
module Snoopit
  class Snooper

    attr :snoopies

    def initialize(logger=nil, log_level=::Logger::INFO)
      @snoopies = []
      Snoopit::Logger.create_logger(logger) unless logger.nil?
      Snoopit.logger.level = log_level
    end

    # Load the configuration from a file
    # @param snoopies_file [String] path to file
    def load_file(snoopies_file)
      raise ArgumentError.new "Invalid Snooper JSON File: #{snoopies_file}" if (snoopies_file.nil?) || (! File.exist? snoopies_file)
      load_array JSON.parse(IO.read(snoopies_file))
    end

    # Load the configuration from a file
    # @param snoopies_json [String] json string
    def load_json(snoopies_json)
      load_array JSON.parse(snoopies_json)
    end

    # Load the configuration from a file
    # @param snoopies_array [Array]
    def load_array(snoopies_array)
      snoopies_array.each do |s|
        @snoopies << Snoopy.new(s)
      end
      raise ArgumentError.new 'There are no Snoopies in the JSON Snooper ' if @snoopies.size == 0
    end

    # Use the snoopies and start snooping
    def snoop
      @snoopies.each do |snoopy|
        if (!snoopy.dir?) && (snoopy.dir?)
          Snoopit.logger.debug "Snooping directory: #{snoopy.dir}"
          dir_processing snoopy
        else
          Snoopit.logger.debug "Snooping file: #{snoopy.input}"
          file_processing snoopy
        end
      end
      get_tracked
    end

    def dir_processing(snoopy)

    end

    def file_processing(snoopy)
      raise ArgumentError.new "Could find file #{snoopy.input}" unless File.exist? snoopy.input
      Snoopit.logger.debug "Processing snoopy: #{snoopy.inspect}"
      line_no = 1
      File.foreach snoopy.input do |line|
        snoopy.sniff snoopy.input, line_no, line
        line_no += 1
      end
    end

    def get_tracked
      tracked = []
      @snoopies.each do |snoopy|
        tracked << snoopy.get_tracked
      end
    end

  end

end
