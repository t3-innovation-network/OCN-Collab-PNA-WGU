# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OCNImporter do
  let(:aws_s3_bucket) { 'aws_s3_bucket' }
  let(:csv_key) { 'data.csv' }
  let(:json_key) { 'data.json' }

  before do
    expect(ENV).to receive(:fetch)
      .with('AWS_S3_BUCKET')
      .and_return(aws_s3_bucket)
      .at_least(:once)
  end

  describe '.import' do
    let(:body) { '{"foo":"bar"}' }
    let(:builder) { double('OCNBuilder') }
    let(:data) { 'CSV data' }
    let(:graph) { { foo: 'bar' } }
    let(:get_object_response) { Struct.new(:body).new(StringIO.new(data)) }

    it 'builds an OCN file and puts it into the bucket' do
      expect(OCNBuilder).to receive(:new).with(data:).and_return(builder)

      expect(builder).to receive(:graph).and_return(graph)

      expect(S3Client).to receive(:get_object)
        .with(
          bucket: aws_s3_bucket,
          key: csv_key
        )
        .and_return(get_object_response)

      expect(S3Client).to receive(:put_object).with(
        body:,
        bucket: aws_s3_bucket,
        key: json_key
      )

      OCNImporter.import(key: csv_key)
    end
  end

  describe '.import_all' do
    let(:list_objects_response) do
      Struct
        .new(:contents)
        .new([
               Aws::S3::Types::Object.new(key: csv_key),
               Aws::S3::Types::Object.new(key: json_key)
             ])
    end

    it 'calls .import for each CSV file in the bucket' do
      expect(OCNImporter).to receive(:import).with(key: csv_key)

      expect(S3Client).to receive(:list_objects_v2)
        .with(bucket: aws_s3_bucket)
        .and_return(list_objects_response)

      OCNImporter.import_all
    end
  end
end
