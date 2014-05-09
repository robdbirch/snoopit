require 'spec_helper'

describe 'File Info' do

  let(:data) {
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

  let (:a_line) { 'D, [2014-05-01T18:48:17.585480 #13186] DEBUG -- : Reading from queue: scores:/queue/scores'}
  let (:diff_line) { 'D, [2014-05-01T19:48:17.585480 #13186] DEBUG -- : Reading from queue: scores:/queue/scores'}

  let(:file) { File.expand_path('../support/log/snoop_log_2.test', __FILE__) }

  it 'initialize with file' do
    fi  = FileInfo.new file
    ap fi
    expect(fi.size).to be > 0
    expect(fi.line_no).to be == 0
    expect(fi.offset).to be == 0
    expect(fi.mtime).not_to be nil
  end

  it 'initialize with NO file' do
    fi  = FileInfo.new
    expect(fi.size).to be == 0
    expect(fi.line_no).to be == 0
    expect(fi.offset).to be == 0
    expect(fi.mtime).to be nil
  end

  context 'File Change' do

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

    it 'append to log creating increase in log size indicating change' do
      fi = FileInfo.new file_dup
      puts "FI #{fi.inspect}"
      fh = File.open file_dup, 'a+'
      data.each do |d|
        fh.write d
      end
      fh.close
      fh = File.open file_dup
      updated = fi.updated? fh
      stat = File.stat file_dup
      expect(updated).to be true
      expect(fi.size).to be == stat.size
      expect(fi.mtime).to be == stat.mtime
    end

    it 'smaller file change' do
      fi = FileInfo.new file_dup
      fh = File.open file_dup, 'w'
      data.each do |d|
        fh.write d
      end
      fh.close
      fh = File.open file_dup
      updated = fi.updated? fh
      stat = File.stat file_dup
      expect(updated).to be true
      expect(fi.size).to be == stat.size
      expect(fi.mtime).to be == stat.mtime
    end

    it 'get last line' do
      begin
        fi = FileInfo.new file_dup
        fh = File.open file_dup, 'w+'
        data.each do |d|
          fi.line_no += 1
          fi.last_line = d
          fh.write d
        end
        ll = fi.get_last_line fh
        expect(ll).to be == fi.last_line
      ensure
        fh.close
      end
    end

    def prime_file_info(fi, fh)
      data.each do |d|
        fi.line_no += 1
        fi.last_line = d
        fh.write d
      end
    end

    it 'size is same but last but mtime is different' do
      fi = FileInfo.new file_dup
      fh = File.open file_dup, 'w+'
      prime_file_info(fi, fh)
      fi.line_no += 1
      fi.last_line = a_line
      fh.write a_line
      fh.close
      fi.stat
      sleep 1
      fh = File.open file_dup, 'w+'
      data.each do |d|
        fh.write d
      end
      fh.write diff_line
      stat = File.stat file_dup
      expect(fi.updated?(fh)).to be true
      fh.close
      expect(fi.size).to be == stat.size
    end
  end
end
