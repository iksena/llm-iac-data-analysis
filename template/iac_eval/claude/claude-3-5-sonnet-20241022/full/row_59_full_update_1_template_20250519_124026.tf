I'll help you create a Terraform configuration for an AWS Kinesis Firehose Delivery Stream with an Extended S3 destination and Dynamic Partitioning enabled. This configuration will include:

1. An S3 bucket as the destination
2. IAM roles and policies for Firehose
3. A Kinesis Firehose Delivery Stream with dynamic partitioning
4. Necessary S3 bucket policies

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
  default     = "data-pipeline"
}

# S3 Bucket for Firehose destination
resource "aws_s3_bucket" "destination" {
  bucket = "${var.app_name}-${var.environment}-firehose-destination"
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM Role for Firehose
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

# IAM Policy for Firehose
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
          aws_s3_bucket.destination.arn,
          "${aws_s3_bucket.destination.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.app_name}-${var.environment}-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.destination.arn

    dynamic_partitioning_configuration {
      enabled = true
    }

    processing_configuration {
      enabled = true

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{year:.timestamp | strftime(\"%Y\"), month:.timestamp | strftime(\"%m\"), day:.timestamp | strftime(\"%d\")}"
        }
      }
    }

    # Dynamic partition pattern
    prefix              = "data/year=!{partitionKeyFromQuery:year}/month=!{partitionKeyFromQuery:month}/day=!{partitionKeyFromQuery:day}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/!{firehose:error-output-type}/"

    buffering_size = 64
    buffering_interval = 60
    compression_format = "GZIP"
  }
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "allow_firehose" {
  bucket = aws_s3_bucket.destination.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowFirehoseAccess"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.destination.arn,
          "${aws_s3_bucket.destination.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket to store the data
2. IAM role and policy for Kinesis Firehose to access the S3 bucket
3. A Kinesis Firehose Delivery Stream with:
   - Extended S3 destination
   - Dynamic partitioning enabled
   - JQ-based metadata extraction for partitioning
   - GZIP compression
   - 64MB buffer size or 60 seconds buffering interval
   - Custom prefix patterns for both data and error outputs
4. S3 bucket policy to allow Firehose access

The dynamic partitioning is configured to partition data based on year, month, and day extracted from the incoming data's timestamp field. The configuration assumes the incoming data is in JSON format and includes a timestamp field.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Make sure you have appropriate AWS credentials configured before running these commands.