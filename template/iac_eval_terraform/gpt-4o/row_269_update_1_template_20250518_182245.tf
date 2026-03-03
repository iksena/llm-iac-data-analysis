provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"
  acl    = "private"
}

resource "aws_s3_bucket_accelerate_configuration" "mybucket_acceleration" {
  bucket = aws_s3_bucket.mybucket.id
  status = "Enabled"
}