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
        Resource = ["*"]
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
    log_stream_arn = aws_cloudwatch_log_stream.analytics_log_stream.arn
    role_arn       = aws_iam_role.kinesis_analytics_role.arn
  }

  code = <<EOF
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
  ticker_symbol VARCHAR(4),
  price         DOUBLE);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS
  INSERT INTO "DESTINATION_SQL_STREAM"
    SELECT STREAM ticker_symbol, price
    FROM "SOURCE_SQL_STREAM_001";
EOF

  inputs {
    name_prefix = "SOURCE_SQL_STREAM"

    schema_version = 1

    kinesis_stream {
      resource_arn = "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/example-stream"
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    starting_position_configuration {
      starting_position = "NOW"
    }
  }
}

# Get current region
data "aws_region" "current" {}

# Get current account ID
data "aws_caller_identity" "current" {}