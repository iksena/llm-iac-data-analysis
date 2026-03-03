provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket-123456"
  acl    = "private"

  tags = {
    Name        = "DataBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456"
  acl    = "log-delivery-write"

  tags = {
    Name        = "LogBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_logging" "data_bucket_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.log_bucket.arn}/log/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          }
          ArnLike = {
            "aws:SourceArn" = "${aws_s3_bucket.data_bucket.arn}"
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}