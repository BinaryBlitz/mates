CarrierWave.configure do |config|
  # Use local storage in development and test environment
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  end

  # Use AWS storage if in production
  if Rails.env.production?
    config.storage = :fog

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: 'eu-west-1'
    }
    config.fog_directory = Rails.application.secrets.aws_s3_bucket_name
  end
end
