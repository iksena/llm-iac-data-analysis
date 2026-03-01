provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "application_name" {
  description = "Name of the Kinesis Analytics application"
  type        = string
  default     = "my-kinesis-analytics-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

# IAM Role for Kinesis Analytics
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis-analytics-application-role"

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

# IAM Policy for Kinesis Analytics
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "kinesis-analytics-application-policy"
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
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "analytics_log_group" {
  name              = "/aws/kinesis-analytics/${var.application_name}"
  retention_in_days = 14
}

# Kinesis Analytics v2 Application
resource "aws_kinesisanalyticsv2_application" "example" {
  name                   = var.application_name
  runtime_environment    = "SQL-1_0"
  service_execution_role = aws_iam_role.kinesis_analytics_role.arn

  application_configuration {
    sql_application_configuration {
      input {
        name_prefix = "PREFIX"

        schema_version = "1"

        starting_position_configuration {
          starting_position = "NOW"
        }
      }
    }

    application_code_configuration {
      code_content {
        text_content = "CREATE OR REPLACE STREAM DESTINATION_SQL_STREAM (column1 VARCHAR(64), column2 VARCHAR(64));"
      }
      code_content_type = "PLAINTEXT"
    }
  }

  cloudwatch_logging_options {
    log_stream_arn = "${aws_cloudwatch_log_group.analytics_log_group.arn}:log-stream:kinesis-analytics-log-stream"
  }

  tags = {
    Environment = var.environment
  }
}