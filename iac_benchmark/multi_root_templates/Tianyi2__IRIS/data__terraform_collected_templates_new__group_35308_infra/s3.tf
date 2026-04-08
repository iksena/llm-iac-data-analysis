resource "aws_s3_bucket" "_" {
  bucket = "moggiez-playbooks-api"
  acl    = "private"

  tags = {
    Project = "moggies.io"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_block_public_access" {
  bucket = aws_s3_bucket._.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}