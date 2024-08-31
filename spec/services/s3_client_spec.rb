# frozen_string_literal: true

require 'spec_helper'

RSpec.describe S3Client do
  let(:aws_access_key_id) { 'aws_access_key_id' }
  let(:aws_s3_region) { 'aws_s3_region' }
  let(:aws_secret_access_key) { 'aws_secret_access_key' }
  let(:method_name) { 'method_name' }
  let(:params) { { foo: 'foo', bar: 'bar' } }
  let(:response) { 'AWS S3 response' }
  let(:s3_client) { double('Aws::S3::Client') }

  it 'delegates everything to an S3 client object' do
    expect(Aws::S3::Client).to receive(:new)
      .with(
        access_key_id: aws_access_key_id,
        region: aws_s3_region,
        secret_access_key: aws_secret_access_key
      )
      .and_return(s3_client)

    expect(ENV).to receive(:fetch)
      .with('AWS_ACCESS_KEY_ID')
      .and_return(aws_access_key_id)

    expect(ENV).to receive(:fetch)
      .with('AWS_S3_REGION')
      .and_return(aws_s3_region)

    expect(ENV).to receive(:fetch)
      .with('AWS_SECRET_ACCESS_KEY')
      .and_return(aws_secret_access_key)

    expect(s3_client).to receive(method_name).with(params).and_return(response)

    expect(S3Client.method_name(**params)).to eq(response)
  end
end
