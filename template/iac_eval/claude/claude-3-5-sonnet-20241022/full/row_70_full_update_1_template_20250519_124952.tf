I'll help you create a Terraform configuration for an AWS Kinesis Firehose Delivery Stream that delivers data to an S3 bucket with extended configuration. This setup will include:

1. An S3 bucket as the destination
2. A Kinesis Firehose Delivery Stream
3. Required IAM roles and policies
4. Extended S3 destination configuration with buffer settings and data processing options

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "environment" {
  description = "Environment name"
  default     = "prod"
}

variable "app_name" {
  description = "Application name"
  default     = "data-ingestion"
}

# Create S3 bucket for Firehose destination
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "${var.app_name}-${var.environment}-firehose-destination"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "firehose_bucket_versioning" {
  bucket = aws_s3_bucket.firehose_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create IAM role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "${var.app_name}-${var.environment}-firehose-role"

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

# Create IAM policy for Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "${var.app_name}-${var.environment}-firehose-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.firehose_bucket.arn,
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Create Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.app_name}-${var.environment}-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.firehose_bucket.arn

    # Buffer configuration
    buffer_size = 64
    buffer_interval = 60

    # S3 backup configuration
    s3_backup_mode = "Disabled"

    # Data processing configuration
    processing_configuration {
      enabled = true

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
      }
    }

    # Dynamic partitioning
    dynamic_partitioning_configuration {
      enabled = true
    }

    # Prefix configuration for S3 objects
    prefix = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"

    # Cloudwatch logging configuration
    cloudwatch_logging_options {
      enabled = true
      log_group_name = "/aws/kinesisfirehose/${var.app_name}-${var.environment}-stream"
      log_stream_name = "S3Delivery"
    }
  }
}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket with versioning enabled to store the delivered data
2. An IAM role and policy that allows Kinesis Firehose to write to the S3 bucket
3. A Kinesis Firehose Delivery Stream with extended S3 configuration that includes:
   - Buffer settings (64MB or 60 seconds)
   - Data processing with metadata extraction
   - Dynamic partitioning
   - Custom prefix configuration for better data organization
   - CloudWatch logging for monitoring
   - Error output handling

The configuration uses variables for environment and application name, which can be customized as needed. The S3 bucket name will be unique based on these variables. The Firehose stream is configured with extended S3 capabilities, including data processing and dynamic partitioning.

To deploy this configuration, you would need appropriate AWS credentials and permissions. The configuration will create all necessary resources in the us-east-1 region by default.