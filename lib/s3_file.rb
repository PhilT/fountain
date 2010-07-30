class S3File
  attr_reader :credentials, :bucket
  attr_writer :bucket

  def initialize(credentials)
    @credentials = credentials
    @bucket = @credentials.delete(:default_bucket)
    @service = S3::Service.new(@credentials)
  end

  def exists?(object_name)
    object object_name
    true
  rescue S3::Error::NoSuchKey
    false
  end

  def download(object_name, path)
    open(path, 'w') do |f|
      f.write object(object_name).content
    end
  end

  def upload(path, object_name, access = :private)
    open(path) do |f|
      bucket = @service.buckets.find(@bucket) #@bucket should have failed when it was a singleton
      s3object = bucket.objects.build(object_name)
      s3object.content = f
      s3object.acl = access
      s3object.save
    end
  end

  def path(path)
    object(path).url rescue nil
  end

  def list(options = {})
    bucket = @service.buckets.find(@bucket)
    bucket.objects.find_all(options)
  end

private
  def object object_name
    @service.buckets.find(bucket).objects.find(object_name)
  end

end

