terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

resource "aws_kinesis_stream" "analytics_input" {
  name            = "analytics-input-stream"
  shard_count     = 1
  retention_period = 24
}

resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis-analytics-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "kinesis-analytics-policy"
  role = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListStreams"
        ],
        Resource = aws_kinesis_stream.analytics_input.arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kinesis_analytics_application" "kda_app" {
  name        = "basic-kinesis-analytics-app"
  description = "Basic Kinesis Analytics Application with input kinesis stream"

  inputs {
    name_prefix = "analytics_input_"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.analytics_input.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema {
      record_format {
        record_format_type = "JSON"

        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }

      record_encoding = "UTF-8"

      record_columns = [
        {
          name    = "data",
          sql_type = "VARCHAR(64)",
          mapping  = "$.data"
        }
      ]
    }
  }
}