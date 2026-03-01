provider "aws" {
  region = "us-east-1"
}

# Data sources for current region and account ID
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

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
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:DescribeStream",
          "kinesis:ListShards"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Kinesis Analytics Application
resource "aws_kinesis_analytics_application" "example" {
  name = "example_kinesis_analytics_app"

  inputs {
    name_prefix = "PREFIX_SQL"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.example.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema_version = 1

    schema {
      record_columns {
        mapping  = "$.example"
        name     = "example_column"
        sql_type = "VARCHAR(8)"
      }

      record_encoding = "UTF-8"

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

# Create a Kinesis stream for input
resource "aws_kinesis_stream" "example" {
  name             = "example-stream"
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "test"
  }
}

# Output the application name and stream name
output "kinesis_analytics_app_name" {
  value = aws_kinesis_analytics_application.example.name
}

output "kinesis_stream_name" {
  value = aws_kinesis_stream.example.name
}