module Db
  class Backup
    attr_accessor :timestamp, :source_environment, :max_backups
    attr_reader :remote_name

    STATS_TABLES = %w()
    STATS_SQL = 'tmp/stats.sql'
    STATS_TAR = 'tmp/stats.sql.tar.gz'

    def initialize(source_environment)
      @timestamp = Time.now
      @source_environment = source_environment
      @max_backups = 48
    end

    def local_name
      "#{local_prefix}/backup.sql.tar.gz"
    end

    def db_name
      Rails.configuration.database_configuration[source_environment]['database']
    end

    def create_timestamp
      @remote_name = backup_remote_name
      filename = "#{local_prefix}/#{Rails.env}.txt"
      File.open(filename, 'w') do |f|
        f.puts self.remote_name
      end
      S3FILE.upload(filename, "#{remote_prefix}.txt")
    end

    def download
      @remote_name = restore_remote_name
      puts "Getting #{remote_name} from S3..."
      S3FILE.download(remote_name, local_name)
    end

    def upload
      @remote_name = backup_remote_name
      puts "Sending to S3..."
      S3FILE.upload(local_name, remote_name)
    end

    def create_backup
      puts "Dumping database to #{BACKUP_SQL}"

      db_config = ActiveRecord::Base.configurations[source_environment]
      cmd = "mysqldump -h #{db_config['host']} -u #{db_config['username']} -p#{db_config['password']} -e --complete-insert -t --single-transaction #{ignore_stats_tables} --ignore-table=#{db_name}.sessions #{db_name} > #{BACKUP_SQL}"
      raise 'MySQL dump failed' if !system(cmd)


      puts "Compressing..."
      Rake::Task['db:schema:dump'].invoke
      system("cp db/schema.rb #{SCHEMA_RB}")
      system("tar cfz #{local_name} #{BACKUP_SQL} #{SCHEMA_RB}")
    end

    def ignore_stats_tables
      STATS_TABLES.map{|table| "--ignore-table=#{db_name}.#{table}"}.join(' ') unless STATS_TABLES.empty?
    end

    def clear_database
      puts "Clearing local database..."
      ENV['SCHEMA'] = SCHEMA_RB
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:schema:load'].invoke

      ActiveRecord::Base.connection.execute 'TRUNCATE TABLE schema_migrations'
    end

    def extract
      puts "Extracting..."
      system("tar xvfz #{local_name}")
    end

    def restore
      puts "Restoring database..."
      db_config = ActiveRecord::Base.configurations[Rails.env]
      cmd = "mysql -D #{db_config['database']} -h #{db_config['host']} --user=#{db_config['username']} --password=#{db_config['password']} -B < #{BACKUP_SQL}"
      raise 'MySQL restore failed' if !system(cmd)
    end

    def create_stats
      puts "Dumping stats data to #{STATS_SQL}"
      db_config = ActiveRecord::Base.configurations[source_environment]
      stats_tables = STATS_TABLES.join(' ')
      cmd = "mysqldump -h #{db_config['host']} -u #{db_config['username']} -p#{db_config['password']} -e -t --single-transaction #{db_name} #{stats_tables} > #{STATS_SQL}"
      raise 'MySQL dump failed' if !system(cmd)

      puts "Compressing..."
      system("tar cfz #{STATS_TAR} #{STATS_SQL}")
    end

    def upload_stats
      puts "Sending to S3..."
      S3FILE.upload(STATS_TAR, "#{source_environment}-stats.sql.tar.gz")
    end

    def download_stats
      s3_name = "#{source_environment}-stats.sql.tar.gz"
      puts "Getting #{s3_name} from S3..."
      S3FILE.download(s3_name, STATS_TAR)
    end

    def extract_stats
      puts "Extracting..."
      system("tar xvfz #{STATS_TAR}")
    end

    def restore_stats
      puts "Clearing stats tables..."
      STATS_TABLES.each do |table|
        ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table}"
      end

      puts "Loading stats..."
      db_config = ActiveRecord::Base.configurations[Rails.env]
      cmd = "mysql -D #{db_config['database']} -h #{db_config['host']} --user=#{db_config['username']} --password=#{db_config['password']} -B < #{STATS_SQL}"
      raise 'MySQL load failed' if !system(cmd)
    end

    def cleanup!
      backups = S3FILE.list(:prefix => "#{remote_prefix}-backup")
      total_backups = backups.size
      if total_backups > max_backups
        backups[0 .. total_backups - max_backups - 1].each do |backup|
          puts "Deleting: #{backup.key}"
          backup.destroy
        end
      else
        puts 'No deleted backups.'
      end
    end

  private

    def local_prefix
      'db/bootstrap'
    end

    def remote_prefix
      "#{db_name}/#{source_environment}"
    end

    def backup_remote_name
      @remote_name = "#{remote_prefix}-backup-#{@timestamp.to_s(:backup)}.sql.tar.gz"
    end

    def restore_remote_name
      filename = "#{local_prefix}/#{source_environment}.txt"
      S3FILE.download("#{remote_prefix}.txt", filename)
      @remote_name = File.read(filename).strip
    end
  end
end

