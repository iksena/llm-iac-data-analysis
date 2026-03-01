provider "aws" {
  region = "us-west-2"
}

variable "http_endpoint_name" {
  description = "Name of the HTTP endpoint"
  type        = string
  default     = "NewRelic"
}

variable "http_endpoint_url" {
  description = "URL of the HTTP endpoint"
  type        = string
  default     = "https://aws-api.newrelic.com/firehose/v1"
}

variable "http_endpoint_access_key" {
  description = "Access key for the HTTP endpoint"
  type        = string
  default     = "your-new-relic-access-key"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_http_role"

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

resource "aws_iam_role_policy" "firehose_policy" {
  name = "firehose_http_policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "firehose_logs" {
  name              = "/aws/kinesisfirehose/http-endpoint-stream"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "HttpDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose_logs.name
}

resource "aws_kinesis_firehose_delivery_stream" "http_stream" {
  name        = "http-endpoint-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = var.http_endpoint_url
    name               = var.http_endpoint_name
    access_key         = var.http_endpoint_access_key
    buffering_size     = 1
    buffering_interval = 60
    retry_duration     = 60
    role_arn          = aws_iam_role.firehose_role.arn

    request_configuration {
      content_encoding = "GZIP"

      common_attributes {
        name  = "timestamp"
        value = "timestamp()"
      }
    }
  }

  server_side_encryption {
    enabled = true
  }
}

output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.http_stream.arn
}