config = YAML.load(open('config/s3_config.yml'))
raise 'Please set credentials in config/initializers/s3_file.rb' if config['access_key_id'].nil?
S3FILE = S3File.new(:access_key_id => config['access_key_id'], :secret_access_key => config['secret_access_key'], :default_bucket => config['default_bucket']) if defined?(S3)

