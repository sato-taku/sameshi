CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_KEY'],
    aws_secret_access_key: ENV['AWS_SEC_KEY'],
    region: 'ap-northeast-1'
  }
  config.fog_directory  = 'sameshi-image'
  config.cache_storage = :fog
end
