require 'time'

module Snoopit
    class FileInfo

      attr_accessor :file, :line_no, :offset, :size, :mtime, :last_line, :init_stat

      def initialize(file=nil)
        @file = file
        @line_no = 0
        @offset = 0
        @size = 0
        @mtime = nil
        @last_line = nil
        @init_stat = true
        stat unless file.nil?
      end

      def file=(file)
        @file = file
        stat
      end

      def stat
        if File.exist? @file
          s = File.stat @file
          @size = s.size
          @mtime = s.mtime
        end
      end

      # Update file Info if the file has changed use the file handle to move the file pointer
      # to the character where reading will start
      #
      # @return [boolean] true if updated false not updated
      def updated?(file_handle)
        stat = File.stat @file
        if (stat.size == @size) && (stat.mtime == @mtime) && (! @init_stat)
          Snoopit.logger.debug 'FileTracker.updated? file has not changed: ' + @file
          updated = false
        elsif (stat.size < @size) || (stat.size == @size)
          updated = new_file? file_handle, stat
        else
          updated = read_from_last file_handle, stat
        end
        @init_stat = false
        updated
      end

      def new_file?(file_handle, stat)
        # seek to 0
        Snoopit.logger.debug "FileTracker.updated? file new read from start of file: #{@file}"
        @offset = 0
        @size = stat.size
        @mtime = stat.mtime
        @last_line = nil
        file_handle.seek 0, IO::SEEK_SET
        true
      end

      def read_from_last(file_handle, stat)
        # seek to last position + 1
        old_size = @size
        @size = stat.size
        @mtime = stat.mtime
        Snoopit.logger.debug "File pointer at byte: #{file_handle.tell}"
        file_handle.seek old_size, IO::SEEK_SET
        Snoopit.logger.debug "Seeked to byte: #{file_handle.tell} destination byte #{old_size} new size #{@size}"
        true
      end

      def get_last_line(file_handle)
        line = nil
        unless @last_line.nil?
          Snoopit.logger.debug "File point at byte: #{file_handle.tell}"
          file_handle.seek (-@last_line.bytesize), IO::SEEK_END
          Snoopit.logger.debug "Seeked to byte: #{file_handle.tell}"
          line = file_handle.readline
        end
        line
      end

      def as_json(*)
        {
            file: @file,
            line_no: @line_no,
            offset: @offset,
            size: @size,
            mtime: @mtime.iso8601,
            last_line: @last_line
        }
      end

      def to_json(*args)
        as_json.to_json(*args)
      end

      def from_json(json_str)
        from_hash JSON.parse(json_str)
      end

      def from_hash(hash)
        @file = hash['file']
        @line_no = hash['line_no']
        @offset = hash['offset']
        @size = hash['size']
        @mtime = Time.parse hash['mtime']
        @last_line = hash['last_line']
        @init_stat = false
      end

    end
end