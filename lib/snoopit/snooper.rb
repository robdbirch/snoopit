require 'json'
module Snoopit
  class Snooper

    attr_accessor :snoopies, :notifier, :file_tracker

    # Snoopies are the list of available named snoopers
    # Snoopers are the current active invocations of selected snoopies
    def initialize(notifications=true, db_file=nil, logger=nil, log_level=::Logger::INFO)
      @snoopies = { }
      @file_tracker = FileTracker.new db_file unless db_file.nil?
      @notifier = NotificationManager.new if notifications
      Snoopit::Logging.create_logger(logger) unless logger.nil?
      Snoopit.logger.level = log_level
    end

    # Load the configuration from a file
    # Calls <code>load_snoopers(json_hash)</code> and <code>load_notifiers(json_hash)</code> and
    # @param snoopies_file [String] path to file
    def load_file(snoopies_file)
      raise ArgumentError.new "Invalid Snooper JSON File: #{snoopies_file}" if (snoopies_file.nil?) || (! File.exist? snoopies_file)
      json_hash = JSON.parse(IO.read(snoopies_file))
      load_snoopers json_hash
      load_notifiers json_hash
    end

    # Load the configuration from a file
    # @param json [String] json string
    def load_json(json)
      json_hash = JSON.parse(json)
      load_snoopers json_hash
      load_notifiers json_hash
    end

    # Load the configuration from a file
    # @param json_hash [Hash]
    def load_snoopers(json_hash)
      snoopies_json = json_hash['snoopers']
      snoopies_json.each do |name, snooper|
        @snoopies[name] =  Snoopy.new(name, snooper)
      end
      raise ArgumentError.new 'There are no Snoopies in the JSON Snooper ' if @snoopies.size == 0
    end

    def load_notifiers(json_hash)
      @notifier.load_notifier_config json_hash['notifiers'] unless @notifier.nil?
    end

    def register_notifier(notifier)
      @notifier.register notifier
    end

    def unregister_notifier(notifier)
      @notifier.unregister notifier
    end

    # Use the snoopies and start snooping
    def snoop(names=[])
      snoopers = get_snoopers names
      snoopers.each do |snoopy|
        if (!snoopy.dir.nil?) && (snoopy.dir?)
          snoop_dir snoopy
        else
          snoop_file snoopy
        end
      end
      @notifier.notify snoopers unless @notifier.nil?
      snoopers
    end

    def get_snoopers(names=[])
      snoopers = []
      use_names = (names.size == 0 ? false : true)
      snoopies.each do |key, snooper|
        if use_names
          snoopers << snooper if names.include? key
        else
          snoopers << snooper
        end
      end
      snoopers
    end

    def snoop_dir(snoopy)
      Snoopit.logger.debug "Snooping directory: #{snoopy.dir}"
      get_files(snoopy).each do |file|
        next if File.directory? file
        sniff_it snoopy, "#{snoopy.dir}/#{file}"
      end
    end

    def get_files(snoopy)
      if snoopy.glob?
        files = get_glob_list snoopy
      else
        files = get_file_list snoopy
      end
      files
    end

    def get_glob_list(snoopy)
      Snoopit.logger.debug "Snooping glob: #{snoopy.glob}"
      cwd = Dir.getwd
      begin
        Dir.chdir snoopy.dir
        files = Dir.glob snoopy.glob
      ensure
        Dir.chdir cwd
      end
      files
    end

    def get_file_list(snoopy)
      Snoopit.logger.debug "Snooper directory: #{snoopy.dir}"
      Dir.entries snoopy.dir
    end

    def snoop_file(snoopy)
      raise ArgumentError.new "Could find file #{snoopy.input}" unless File.exist? snoopy.input
      Snoopit.logger.debug "Snooping file: #{snoopy.input} with snoopy: #{snoopy.name}"
      sniff_it snoopy, snoopy.input
    end

    def sniff_it(snoopy, file_name)
      Snoopit.logger.debug "Sniffing file: #{file_name} with snoopy: #{snoopy.name}"
      unless @file_tracker.nil?
        file_track_read(snoopy, file_name)
      else
        file_read(snoopy, file_name)
      end
    end

    def file_track_read(snoopy, file_name)
      @file_tracker.foreach file_name do |line, line_no|
        snoopy.sniff snoopy.input, line_no, line
      end
    end

    def file_read(snoopy, file_name)
      line_no = 0
      File.foreach file_name do |line|
        snoopy.sniff snoopy.input, line_no, line
        line_no += 1
      end
    end

  end

end
