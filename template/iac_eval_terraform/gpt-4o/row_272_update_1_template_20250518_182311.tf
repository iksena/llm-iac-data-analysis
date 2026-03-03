provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "mybucket"

  lifecycle_rule {
    id      = "IntelligentTiering"
    enabled = true

    transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "mybucket_tiering" {
  bucket = aws_s3_bucket.mybucket.id
  name   = "IntelligentTieringConfig"

  tiering {
    days          = 30
    access_tier   = "ARCHIVE_ACCESS"
  }

  tiering {
    days          = 60
    access_tier   = "DEEP_ARCHIVE_ACCESS"
  }
}