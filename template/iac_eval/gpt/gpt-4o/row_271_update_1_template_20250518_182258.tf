provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "source_bucket" {
  bucket = "mybucket"
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket_prefix = "analytics-results-"
}

resource "aws_iam_role" "analytics_role" {
  name = "s3-analytics-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "analytics_policy" {
  name        = "s3-analytics-policy"
  description = "Policy to allow S3 analytics to export data to another bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.destination_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "analytics_policy_attachment" {
  role       = aws_iam_role.analytics_role.name
  policy_arn = aws_iam_policy.analytics_policy.arn
}

resource "aws_s3_bucket_analytics_configuration" "analytics_config" {
  bucket = aws_s3_bucket.source_bucket.id
  name   = "EntireBucketAnalytics"

  storage_class_analysis {
    data_export {
      output_schema_version = "V_1"
      destination {
        s3_bucket_destination {
          bucket_arn = aws_s3_bucket.destination_bucket.arn
          format     = "CSV"
          role_arn   = aws_iam_role.analytics_role.arn
        }
      }
    }
  }
}