provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"
}

resource "aws_s3_bucket_ownership_controls" "mybucket_ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "mybucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.mybucket_ownership]
}