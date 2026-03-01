provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket_logging" "data_bucket_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}