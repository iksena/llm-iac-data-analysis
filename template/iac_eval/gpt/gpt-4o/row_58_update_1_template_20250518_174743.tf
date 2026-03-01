provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "kinesis_analytics_role" {
  name = "KinesisAnalyticsFlinkRole"
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

resource "aws_iam_policy" "kinesis_analytics_policy" {
  name        = "KinesisAnalyticsFlinkPolicy"
  description = "Policy for Kinesis Analytics Flink Application"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListStreams",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_analytics_role_attach" {
  role       = aws_iam_role.kinesis_analytics_role.name
  policy_arn = aws_iam_policy.kinesis_analytics_policy.arn
}

resource "aws_kinesisanalyticsv2_application" "flink_app" {
  name        = "FlinkApplication"
  runtime_environment = "FLINK-1_11"
  service_execution_role = aws_iam_role.kinesis_analytics_role.arn

  application_configuration {
    application_code_configuration {
      code_content {
        text_content = "public class SampleFlinkApp { public static void main(String[] args) { /* Flink application code */ } }"
      }
      code_content_type = "PLAINTEXT"
    }
  }
}