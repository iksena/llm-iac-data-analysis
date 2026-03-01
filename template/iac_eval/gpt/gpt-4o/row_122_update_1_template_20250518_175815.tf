provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "your_bucket_name"
  acl    = "private"
}

resource "aws_s3_bucket_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "new_object_key"
  source = "path/to/file"
  acl    = "private"
}