provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "mybucket_object" {
  bucket = aws_s3_bucket.mybucket.bucket
  key    = "uploaded-file"
  source = "path/to/file"
  acl    = "private"
}