DB2S3::Config.instance_eval do
  S3 = {
    :access_key_id     => ENV['ACCESS_KEY_ID'],
    :secret_access_key => ENV['SECRET_ACCESS_KEY'],
    :bucket            => ENV['BACKUP_BUCKET']
  }
end

