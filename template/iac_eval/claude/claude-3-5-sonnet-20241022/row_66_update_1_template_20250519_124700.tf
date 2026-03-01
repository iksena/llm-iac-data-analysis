provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "http_endpoint_name" {
  description = "Name of the HTTP endpoint"
  default     = "NewRelic"
}

variable "http_endpoint_url" {
  description = "URL of the HTTP endpoint"
  default     = "https://aws-api.newrelic.com/firehose/v1"
}

variable "http_endpoint_access_key" {
  description = "Access key for the HTTP endpoint"
  default     = "your-new-relic-access-key"
}

# IAM Role for Firehose
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

# IAM Policy for Firehose
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
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "http_stream" {
  name        = "http-endpoint-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    url                = var.http_endpoint_url
    name               = var.http_endpoint_name
    access_key        = var.http_endpoint_access_key
    buffering_size    = 1
    buffering_interval = 60
    retry_duration    = 60
    role_arn          = aws_iam_role.firehose_role.arn
    
    request_configuration {
      content_encoding = "GZIP"

      common_attributes {
        name  = "timestamp"
        value = "${timestamp()}"
      }
    }
  }

  cloudwatch_logging_options {
    enabled         = true
    log_group_name  = "/aws/kinesisfirehose/http-endpoint-stream"
    log_stream_name = "HttpDelivery"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "firehose_logs" {
  name              = "/aws/kinesisfirehose/http-endpoint-stream"
  retention_in_days = 14
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "HttpDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose_logs.name
}

# Output the Firehose ARN
output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.http_stream.arn
}