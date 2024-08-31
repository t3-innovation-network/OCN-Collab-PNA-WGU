# frozen_string_literal: true

# Converts CSVs in the bucket to OCN files
class OCNImporter
  class << self
    def bucket
      ENV.fetch('AWS_S3_BUCKET')
    end

    def fetch_data(key:)
      S3Client.get_object(bucket:, key:).body.read
    end

    def import(key:)
      data = fetch_data(key:)
      graph = OCNBuilder.new(data:).graph
      upload(body: graph.to_json, key: key.gsub(/\.csv$/, '.json'))
    end

    def import_all
      s3_objects
        .map { import(key: _1.key) if _1.key.end_with?('.csv') }
        .compact
        .size
    end

    def s3_objects
      S3Client.list_objects_v2(bucket:).contents
    end

    def upload(body:, key:)
      S3Client.put_object(body:, bucket:, key:)
    end
  end
end
