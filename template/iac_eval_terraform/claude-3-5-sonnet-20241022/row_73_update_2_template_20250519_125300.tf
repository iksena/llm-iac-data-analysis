provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Kinesis Analytics
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis_analytics_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Kinesis Analytics
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "kinesis_analytics_policy"
  role = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "analytics_log_group" {
  name              = "/aws/kinesis-analytics/MyAnalyticsApp"
  retention_in_days = 14
}

# Create CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "analytics_log_stream" {
  name           = "analytics-stream"
  log_group_name = aws_cloudwatch_log_group.analytics_log_group.name
}

# Create Kinesis Analytics Application
resource "aws_kinesis_analytics_application" "example" {
  name = "my-analytics-application"

  cloudwatch_logging_options {
    log_stream_arn = "${aws_cloudwatch_log_group.analytics_log_group.arn}:${aws_cloudwatch_log_stream.analytics_log_stream.name}"
    role_arn       = aws_iam_role.kinesis_analytics_role.arn
  }

  inputs {
    name_prefix = "SOURCE_SQL_STREAM"

    schema_version = 1

    starting_position_configuration {
      starting_position = "NOW"
    }

    kinesis_firehose {
      resource_arn = aws_kinesis_firehose_delivery_stream.example.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema {
      record_columns {
        name     = "ticker_symbol"
        sql_type = "VARCHAR(4)"
        mapping  = "$.ticker_symbol"
      }

      record_columns {
        name     = "price"
        sql_type = "DOUBLE"
        mapping  = "$.price"
      }

      record_format {
        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }
    }
  }
}

# Create a Kinesis Firehose for input (required for the analytics application)
resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "terraform-kinesis-firehose-example"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.kinesis_analytics_role.arn
    bucket_arn = aws_s3_bucket.example.arn
  }
}

# Create S3 bucket for Kinesis Firehose
resource "aws_s3_bucket" "example" {
  bucket = "my-analytics-destination-bucket"
}

# Add bucket versioning
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}