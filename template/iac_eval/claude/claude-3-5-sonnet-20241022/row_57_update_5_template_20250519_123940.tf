provider "aws" {
  region = "us-east-1"
}

# Variables
variable "app_name" {
  description = "Name of the Kinesis Analytics application"
  type        = string
  default     = "my-kinesis-analytics-app"
}

variable "input_stream_name" {
  description = "Name of the input Kinesis stream"
  type        = string
  default     = "input-stream"
}

# Create IAM role for Kinesis Analytics
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis-analytics-role"

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
  name = "kinesis-analytics-policy"
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
        Resource = [aws_kinesis_stream.input_stream.arn]
      }
    ]
  })
}

# Create Kinesis Data Stream
resource "aws_kinesis_stream" "input_stream" {
  name             = var.input_stream_name
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = "dev"
  }
}

# Create Kinesis Analytics Application
resource "aws_kinesis_analytics_application" "example" {
  name = var.app_name
  code = "CREATE OR REPLACE STREAM \"DESTINATION_SQL_STREAM\" (example_column VARCHAR(8));"

  inputs {
    name_prefix = "SOURCE_SQL_STREAM"
    kinesis_stream {
      resource_arn = aws_kinesis_stream.input_stream.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema_version = "1"

    processing_configuration {
      lambda {
        resource_arn = "arn:aws:lambda:us-east-1:123456789012:function:example"
        role_arn     = aws_iam_role.kinesis_analytics_role.arn
      }
    }

    starting_position_configuration {
      starting_position = "NOW"
    }

    schema {
      record_columns {
        mapping  = "$.example"
        name     = "example_column"
        sql_type = "VARCHAR(8)"
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