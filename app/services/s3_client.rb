# frozen_string_literal: true

# An instantiated S3 client
class S3Client < Delegator
  class << self
    def method_missing(method_name, **args)
      s3_client.send(method_name, **args)
    end

    def respond_to_missing?(method_name, *_args)
      Aws::S3::Client.method_defined?(method_name)
    end

    private

    def s3_client
      @s3_client ||= Aws::S3::Client.new(
        access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
        region: ENV.fetch('AWS_S3_REGION'),
        secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
      )
    end
  end
end
