provider "aws" {
  region = var.aws_region
}

# Create a random suffix for unique S3 bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create an S3 bucket to be used as backup for failed Splunk deliveries
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "kinesis-firehose-backup-${random_id.bucket_suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Kinesis Firehose Backup Bucket"
  }
}

# IAM Role for Kinesis Firehose with a trust relationship for firehose.amazonaws.com
resource "aws_iam_role" "firehose_role" {
  name = "kinesis_firehose_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for the Firehose role to allow access to the S3 bucket
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "kinesis_firehose_policy"
  role   = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.firehose_bucket.arn
        ]
      },
      {
        Action = [
          "s3:PutObject"
        ],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream with Splunk destination configuration
resource "aws_kinesis_firehose_delivery_stream" "firehose_splunk" {
  name = "kinesis-firehose-splunk-delivery"

  splunk_configuration {
    hec_endpoint          = var.hec_endpoint
    hec_endpoint_type     = var.hec_endpoint_type
    hec_token             = var.hec_token
    retry_duration        = var.retry_duration

    s3_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = aws_s3_bucket.firehose_bucket.arn
      buffering_interval = var.s3_buffering_interval
      buffering_size     = var.s3_buffering_size
      compression_format = var.s3_compression_format
      prefix             = var.s3_prefix
    }
  }
}

# Variables with default values
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "hec_endpoint" {
  description = "Splunk HTTP Event Collector endpoint (URL) for the Firehose delivery stream"
  type        = string
  default     = "https://http-inputs-my-splunk-instance:8088"
}

variable "hec_endpoint_type" {
  description = "Type of the Splunk HEC endpoint (Raw or Event)"
  type        = string
  default     = "Raw"
}

variable "hec_token" {
  description = "Splunk HEC token for authentication"
  type        = string
  default     = "example-token"
}

variable "retry_duration" {
  description = "Retry duration (in seconds) to resend data to Splunk if the first attempt fails"
  type        = number
  default     = 300
}

variable "s3_buffering_interval" {
  description = "The buffering interval (in seconds) for S3 backup"
  type        = number
  default     = 300
}

variable "s3_buffering_size" {
  description = "The buffering size (in MB) for S3 backup"
  type        = number
  default     = 5
}

variable "s3_compression_format" {
  description = "The compression format for S3 backup"
  type        = string
  default     = "UNCOMPRESSED"
}

variable "s3_prefix" {
  description = "S3 object key prefix for backup data"
  type        = string
  default     = "splunk-backup/"
}

# Ensure the random provider is available
provider "random" {
  # No configuration required
}