provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456789"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "LogBucket"
    Environment = "Dev"
  }
}

resource "aws_sns_topic" "log_topic" {
  name = "log-notification-topic"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.log_bucket.id

  topic {
    topic_arn = aws_sns_topic.log_topic.arn
    events    = ["s3:ObjectCreated:*"]

    filter_suffix = ".log"
  }
}