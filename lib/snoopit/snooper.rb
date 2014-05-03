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
        if snoopy.dir?
          dir_processing snoopy
        else
          file_processing snoopy
        end
      end
    end

    def dir_processing(snoopy)

    end

    def file_processing(snoopy)
      raise ArgumentError.new "Could find file #{snoopy.input}" unless File.exist? snoopy.input
      File.open snoopy.input do |f|
        line = f.readline
        snoopy.sniff line
      end
    end

  end

end
