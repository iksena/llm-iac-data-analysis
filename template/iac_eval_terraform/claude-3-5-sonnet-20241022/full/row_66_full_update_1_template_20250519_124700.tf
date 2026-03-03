I'll help you create a Terraform configuration for an AWS Kinesis Firehose Delivery Stream that sends data to an HTTP endpoint (like New Relic). The configuration will include:

1. A Kinesis Firehose Delivery Stream
2. An IAM role for Firehose with necessary permissions
3. HTTP endpoint configuration with authentication
4. Buffer settings and retry options
5. Required provider configuration

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for HTTP endpoint configuration with default values
3. An IAM role and policy for the Firehose service
4. A Kinesis Firehose Delivery Stream configured with:
   - HTTP endpoint destination
   - GZIP content encoding
   - Buffer settings (1MB or 60 seconds)
   - Retry duration of 60 seconds
   - CloudWatch logging enabled
5. CloudWatch Log Group and Stream for monitoring
6. Output for the Firehose ARN

To use this configuration:

1. Replace the default value of `http_endpoint_access_key` with your actual New Relic access key
2. Adjust the `http_endpoint_url` if you're using a different endpoint
3. Modify the buffer settings and retry duration as needed
4. Customize the CloudWatch log retention period if required

The configuration includes all necessary components for a working Kinesis Firehose with HTTP endpoint destination, including proper IAM roles and logging capabilities.