require 'spec_helper'

describe 'File Tracker' do

  let(:file) { File.expand_path('../support/log/snoop_log_2.test', __FILE__) }

  let(:append_data) {
    [
        'I, [2014-05-01T18:48:17.532019 #13186]  INFO -- : Total Number of records received: 3',
        'W, [2014-05-01T18:48:17.584228 #13186]  WARN -- : Failed to bulk load 3 records',
        'W, [2014-05-01T18:48:17.584287 #13186]  WARN -- : PG::NotNullViolation: ERROR:  null value in column "scout_id" violates not-null constraint',
        ': INSERT INTO "posts" ("author", "body", "created_at", "enterprise_id", "label", "ldate", "leadprob", "lid", "loadstamp", "notleadprob", "scout_id", "sentiment", "source", "state", "updated_at", "url", "user_id") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17) RETURNING "id"',
        'W, [2014-05-01T18:48:17.584322 #13186]  WARN -- : ["/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/postgresql_adapter.rb:786:in `get_last_result\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/postgresql_adapter.rb:786:in `exec_cache\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/postgresql/database_statements.rb:139:in `block in exec_query\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract_adapter.rb:435:in `block in log\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activesupport-4.0.3/lib/active_support/notifications/instrumenter.rb:20:in `instrument\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract_adapter.rb:430:in `log\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/postgresql/database_statements.rb:137:in `exec_query\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/postgresql/database_statements.rb:184:in `exec_insert\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract/database_statements.rb:96:in `insert\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract/query_cache.rb:14:in `insert\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/relation.rb:76:in `insert\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:509:in `create_record\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/attribute_methods/dirty.rb:78:in `create_record\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/callbacks.rb:306:in `block in create_record\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activesupport-4.0.3/lib/active_support/callbacks.rb:373:in `_run__1901135813518085503__create__callbacks\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activesupport-4.0.3/lib/active_support/callbacks.rb:80:in `run_callbacks\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/callbacks.rb:306:in `create_record\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/timestamp.rb:57:in `create_record\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:477:in `create_or_update\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/callbacks.rb:302:in `block in create_or_update\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activesupport-4.0.3/lib/active_support/callbacks.rb:413:in `_run__1901135813518085503__save__callbacks\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activesupport-4.0.3/lib/active_support/callbacks.rb:80:in `run_callbacks\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/callbacks.rb:302:in `create_or_update\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:106:in `save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/validations.rb:51:in `save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/attribute_methods/dirty.rb:32:in `save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:270:in `block (2 levels) in save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:326:in `block in with_transaction_returning_status\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract/database_statements.rb:202:in `block in transaction\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract/database_statements.rb:210:in `within_new_transaction\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/connection_adapters/abstract/database_statements.rb:202:in `transaction\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:209:in `transaction\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:323:in `with_transaction_returning_status\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:270:in `block in save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:281:in `rollback_active_record_state!\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/transactions.rb:269:in `save\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:37:in `create\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:34:in `block in create\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:34:in `collect\'", "/usr/local/rvm/gems/ruby-2.0.0-p195@sociallens/gems/activerecord-4.0.3/lib/active_record/persistence.rb:34:in `create\'", "/home/noxaos/pipeline/lib/pipeline/prediction_loader.rb:187:in `bulk_load\'", "/home/noxaos/pipeline/lib/pipeline/prediction_loader.rb:299:in `run\'", "/home/noxaos/pipeline/bin/prediction_loader_server:55:in `<main>\'"]',
        'I, [2014-05-01T18:48:17.585436 #13186]  INFO -- : Prediction loader waiting for scores ...',
        'D, [2014-05-01T18:48:17.585480 #13186] DEBUG -- : Reading from queue: scores:/queue/scores'
    ]
  }

  let(:file_dup) { File.expand_path('../support/log/snoop_log_3.test', __FILE__) }

  before(:each) {
    duplicate
  }

  after(:each) {
    File.delete file_dup
  }

  def duplicate
    File.copy_stream(file, file_dup)
  end

  context 'no database' do

    before(:each) do
      #Snoopit.logger.level = Logger::DEBUG
      @ft = FileTracker.new nil
    end

    def read_init(file, data)
      @ft.foreach file do |line, line_no |
        data << line
      end
    end

    it 'initially reads a new file' do
      data = []
      read_init file_dup, data
      fi2 = @ft.get_file file_dup
      expect(data.size).to be == fi2.line_no
    end

    it 'reads an appended file' do
      data = []
      read_init file_dup, data
      fh = File.open file_dup, 'a'
      append_data.each do |line|
        fh.puts "#{line}"
      end
      fh.close
      appended = []
      @ft.foreach file_dup do |line, line_no|
        appended << line
      end
      expect(appended.size).to be == append_data.size
      (0...append_data.size).each do |i|
        expect(append_data[i]).to be == appended[i].chop
      end
    end

    it 'reads a new version of file file' do
      data = []
      read_init file_dup, data
      old_size = @ft.get_file(file_dup).size
      fh = File.open file_dup, 'w'
      append_data.each do |line|
        fh.puts "#{line}"
      end
      fh.close
      new_data = []
      @ft.foreach file_dup do |line, line_no|
        new_data << line
      end
      expect(append_data.size).to be == new_data.size
      expect(old_size).to_not be == new_data.size
      (0...append_data.size).each do |i|
        expect(append_data[i]).to be == new_data[i].chop
      end
    end

  end

  context 'with log database' do

    before(:each) do
      file_path = File.expand_path('../support/db/snoop_db.json', __FILE__)
      Dir.mkdir './spec/support/db' unless Dir.exist? './spec/support/db'
      #Snoopit.logger.level = Logger::DEBUG
      @db_file = file_path
      File.delete @db_file if File.exist? @db_file
      @ft = FileTracker.new @db_file
    end

    def read_init(file, data)
      @ft.foreach file do |line, line_no |
        data << line
      end
    end

    it 'initially reads a new file save to db validate db save and load' do
      data = []
      read_init file_dup, data
      dup = @ft.get_file file_dup
      expect(data.size).to be == dup.line_no
      @ft2 = FileTracker.new @db_file
      ft_json_read = @ft2.get_file file_dup
      expect(ft_json_read.size).to be == dup.size
      expect(ft_json_read.mtime.to_i).to be == dup.mtime.to_i
      expect(ft_json_read.line_no).to be == dup.line_no
      expect(ft_json_read.file).to be == dup.file
      expect(ft_json_read.offset).to be == dup.offset
    end

    it 'read db ans sees appended file' do
      data = []
      read_init file_dup, data
      dup = @ft.get_file file_dup
      expect(data.size).to be == dup.line_no
      fh = File.open file_dup, 'a'
      append_data.each do |line|
        fh.puts "#{line}"
      end
      fh.close
      appended = []
      @ft2 = FileTracker.new @db_file
      @ft2.foreach file_dup do |line, line_no|
        appended << line
      end
      expect(appended.size).to be == append_data.size
      (0...append_data.size).each do |i|
        expect(append_data[i]).to be == appended[i].chop
      end
      fi2 = @ft2.get_file file_dup
      stat = File.stat file_dup
      expect(fi2.size).to be == stat.size
      expect(fi2.mtime).to be == stat.mtime
    end

    it 'reads db sees a new version of file' do
      data = []
      read_init file_dup, data
      old_size = @ft.get_file(file_dup).size
      fh = File.open file_dup, 'w'
      append_data.each do |line|
        fh.puts "#{line}"
      end
      fh.close
      new_data = []
      @ft2 = FileTracker.new @db_file
      @ft2.foreach file_dup do |line, line_no|
        new_data << line
      end
      expect(append_data.size).to be == new_data.size
      expect(old_size).to_not be == new_data.size
      (0...append_data.size).each do |i|
        expect(append_data[i]).to be == new_data[i].chop
      end
    end

  end

end