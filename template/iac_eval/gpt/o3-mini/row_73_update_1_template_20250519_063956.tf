terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

# CloudWatch Log Group for Kinesis Analytics logging
resource "aws_cloudwatch_log_group" "kinesis_log_group" {
  name              = "kinesis-analytics-log-group"
  retention_in_days = 7
}

# CloudWatch Log Stream within the Log Group
resource "aws_cloudwatch_log_stream" "kinesis_log_stream" {
  name           = "kinesis-analytics-log-stream"
  log_group_name = aws_cloudwatch_log_group.kinesis_log_group.name
}

# Kinesis input stream resource for the analytics application
resource "aws_kinesis_stream" "input_stream" {
  name             = "kinesis-input-stream"
  shard_count      = 1
  retention_period = 24
}

# IAM Role for Kinesis Analytics with trust policy for the service principal
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis-analytics-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "kinesisanalytics.amazonaws.com"
      }
    }]
  })
}

# IAM Policy granting read permissions on the Kinesis input stream for the application
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name   = "kinesis-analytics-policy"
  role   = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords"
        ]
        Effect   = "Allow"
        Resource = aws_kinesis_stream.input_stream.arn
      }
    ]
  })
}

# Amazon Kinesis Analytics Application
resource "aws_kinesis_analytics_application" "this" {
  name = "basic-kinesis-analytics-app"

  # Basic SQL code snippet for the application (placeholder code)
  code = <<EOF
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (dummy VARCHAR(16));
EOF

  # Input configuration for a Kinesis data stream
  inputs {
    name_prefix = "exampleInput"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.input_stream.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    starting_position_configuration {
      starting_position = "NOW"
    }
  }

  # Attach CloudWatch logging options for the application
  cloudwatch_logging_options {
    log_stream_arn = aws_cloudwatch_log_stream.kinesis_log_stream.arn
  }
}