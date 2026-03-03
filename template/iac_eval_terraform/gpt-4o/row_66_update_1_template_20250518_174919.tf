provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "firehose_delivery_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_delivery_policy" {
  name        = "firehose_delivery_policy"
  description = "Policy for Kinesis Firehose to deliver data to HTTP endpoint"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_delivery_policy_attachment" {
  role       = aws_iam_role.firehose_delivery_role.name
  policy_arn = aws_iam_policy.firehose_delivery_policy.arn
}

resource "aws_kinesis_firehose_delivery_stream" "http_delivery_stream" {
  name        = "http_delivery_stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = "https://example.newrelic.com/endpoint"
    name               = "NewRelicEndpoint"
    role_arn           = aws_iam_role.firehose_delivery_role.arn
    buffering_size     = 5
    buffering_interval = 300
    retry_duration     = 300

    request_configuration {
      content_encoding = "GZIP"
    }
  }
}