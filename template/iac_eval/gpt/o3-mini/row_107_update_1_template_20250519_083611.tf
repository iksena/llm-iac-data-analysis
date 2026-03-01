provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sample" {
  bucket = "sample"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "sample_versioning" {
  bucket = aws_s3_bucket.sample.id

  versioning_configuration {
    status = "Enabled"
  }

  expected_bucket_owner = "123456789012"
}