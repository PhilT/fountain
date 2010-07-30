namespace :db do
  BACKUP_SQL = 'db/bootstrap/backup.sql'
  SCHEMA_RB = 'db/bootstrap/schema.rb'
  BACKUP_SQL_ARCHIVE = 'db/bootstrap/backup.sql.tar.gz'

  desc "Backup Live Database"
  task :backup => :environment do
    backup = Db::Backup.new(Rails.env)

    backup.create_backup
    backup.create_timestamp
    backup.upload

    puts "Backup complete."
  end

  desc "Restore a previous backup from S3 to local database. [FROM_ENV=environment]"
  task :restore => :environment do

    backup = Db::Backup.new(ENV['FROM_ENV'] || Rails.env)

    if ENV['FROM_ENV'].nil?
      if File.exists?(backup.local_name)
        puts "Using existing backup file"
      else
        puts "Please supply the environment you want to restore from with FROM_ENV=environment"
        exit
      end
    elsif File.exists?(backup.local_name) && File.new(BACKUP_SQL).mtime.to_date == Date.today
      puts "Using todays backup file"
    else
      backup.download
    end

    backup.extract
    backup.clear_database
    backup.restore

    puts "Restore complete."
  end

  namespace :backup do

    desc "Backup Live Stats Data"
    task :stats => :environment do

      backup = Db::Backup.new(Rails.env)
      backup.create_stats
      backup.upload_stats

      puts "Backup complete."
    end
  end

  namespace :load do

    desc "Restore a previous stats backup from S3 to local database. [FROM_ENV=environment]"
    task :stats => :environment do

      backup = Db::Backup.new(ENV['FROM_ENV'] || Rails.env)
      if ENV['FROM_ENV'].nil?
        puts "Please supply the environment you want to restore from with FROM_ENV=environment"
        exit
      else
        backup.download_stats
      end

      backup.extract_stats
      backup.restore_stats

      puts "Restore complete."
    end
  end

  desc 'Remove old backup files'
  task :cleanup => :environment do
    backup = Db::Backup.new(Rails.env)
    backup.cleanup!
  end

end

