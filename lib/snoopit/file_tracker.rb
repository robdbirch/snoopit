module Snoopit
  class FileTracker

    attr_accessor :files, :db_file

    def initialize(db_file='./snooper_db.json', remove=false)
      @files = { }
      @db_file = db_file
      if remove
        remove_db @db_file
      else
        load_db @db_file
      end
    end

    def foreach(file, &block)
      file_info = get_file(file)
      unless file_info.nil?
        read_lines(file_info, block)
        save_db @db_file
      end
    end

    def get_file(file)
      return nil unless File.exist? file
      @files[file] = FileInfo.new(file) if @files[file].nil?
      @files[file]
    end

    def read_lines(file_info, block)
      begin
        fh = File.new(file_info.file)
        if file_info.updated? fh
          fh.each_line do |line|
            file_info.offset += line.bytesize
            file_info.line_no += 1
            file_info.last_line = line
            block.call line, file_info.line_no
          end
        end
      ensure
        fh.close
      end
    end

    def load_db(db_file)
      if (! db_file.nil?) && (File.exist? db_file)
        hash_db = JSON.parse(IO.read db_file)
        hash_db.each do |key, file_info|
          unless file_info.nil?
            fi = FileInfo.new
            fi.from_hash(file_info)
            @files[key] = fi
          end
        end
      end
    end

    def save_db(db_file)
      unless  db_file.nil?
        File.open db_file, 'w' do |f|
          f.write @files.to_json
        end
      end
    end

    def remove_db(db_file)
      if (! db_file.nil?) && (File.exist? db_file)
        File.delete db_file
      end
    end

    def as_json(*)
      { files: @files  }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

  end
end