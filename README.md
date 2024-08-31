# OCN WGU PNA

A provider node agent (PNA) for Western Governors University (WGU).

## System dependencies

- Ruby 3.3 or higher.

## Configuration

Set the following environment variables:

- AWS_ACCESS_KEY_ID
- AWS_S3_BUCKET
- AWS_S3_REGION
- AWS_SECRET_ACCESS_KEY

## Building OCN import files

To build OCN import files from CSV files in the bucket, run

```
  rake ocn:import
```
