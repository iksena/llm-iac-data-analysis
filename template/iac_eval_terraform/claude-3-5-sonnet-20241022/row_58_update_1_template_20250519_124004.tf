provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "app_name" {
  description = "Name of the Kinesis Analytics application"
  default     = "flink-application"
}

variable "environment" {
  description = "Environment name"
  default     = "development"
}

# S3 bucket for storing application code
resource "aws_s3_bucket" "application_code" {
  bucket = "${var.app_name}-code-${random_string.suffix.result}"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# IAM role for Kinesis Analytics
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "${var.app_name}-kinesis-analytics-role"

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

# IAM policy for Kinesis Analytics
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "${var.app_name}-kinesis-analytics-policy"
  role = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.application_code.arn,
          "${aws_s3_bucket.application_code.arn}/*"
        ]
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

# CloudWatch log group
resource "aws_cloudwatch_log_group" "analytics_log_group" {
  name              = "/aws/kinesis-analytics/${var.app_name}"
  retention_in_days = 14
}

# Kinesis Analytics v2 Application
resource "aws_kinesisanalyticsv2_application" "example" {
  name                   = var.app_name
  runtime_environment    = "FLINK-1_13"
  service_execution_role = aws_iam_role.kinesis_analytics_role.arn

  application_configuration {
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = aws_s3_bucket.application_code.arn
          file_key   = "flink-app.jar"
        }
      }
      code_content_type = "ZIPFILE"
    }

    environment_properties {
      property_group {
        property_group_id = "ProducerConfigProperties"
        property_map = {
          environment = var.environment
        }
      }
    }

    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = "DEFAULT"
      }
      monitoring_configuration {
        configuration_type = "DEFAULT"
        log_level         = "INFO"
        metrics_level     = "APPLICATION"
      }
      parallelism_configuration {
        configuration_type = "DEFAULT"
        parallelism       = 1
        parallelism_per_kpu = 1
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}