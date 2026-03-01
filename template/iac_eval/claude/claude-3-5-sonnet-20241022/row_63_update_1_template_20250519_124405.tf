provider "aws" {
  region = "us-east-1"
}

# Variables
variable "splunk_endpoint" {
  description = "Splunk endpoint URL"
  type        = string
  default     = "https://splunk.example.com:8088"
}

variable "splunk_token" {
  description = "Splunk HEC token"
  type        = string
  default     = "your-splunk-token"
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose_splunk_role"

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
  name = "firehose_splunk_policy"
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

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "splunk_stream" {
  name        = "splunk-delivery-stream"
  destination = "splunk"

  splunk_configuration {
    hec_endpoint               = var.splunk_endpoint
    hec_token                 = var.splunk_token
    hec_acknowledgment_timeout = 600
    hec_endpoint_type         = "Raw"
    retry_duration            = 3600

    processing_configuration {
      enabled = true

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{$.timestamp}"
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/splunk-delivery-stream"
      log_stream_name = "SplunkDelivery"
    }
  }

  tags = {
    Environment = "Production"
    Service     = "Splunk-Integration"
  }

  depends_on = [aws_iam_role_policy.firehose_policy]
}

# CloudWatch Log Group for Firehose
resource "aws_cloudwatch_log_group" "firehose_logs" {
  name              = "/aws/kinesisfirehose/splunk-delivery-stream"
  retention_in_days = 14
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "SplunkDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose_logs.name
}