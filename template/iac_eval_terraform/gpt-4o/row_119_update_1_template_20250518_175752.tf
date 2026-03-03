provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "my_kms_key" {
  description         = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-123456"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.my_kms_key.arn
    }
  }
}