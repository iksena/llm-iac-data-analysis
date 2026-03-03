Below is the complete Terraform configuration. In this example we create an Amazon OpenSearch Serverless collection, an S3 bucket for backup of any failed documents, an IAM role (with an inline policy) that authorizes Kinesis Firehose to both write to S3 and interact with the OpenSearch Serverless collection, and finally a Kinesis Firehose delivery stream that uses the OpenSearch Serverless destination configuration.

Review and adjust any permissions (or parameters) before deploying in your account.

<iac_template>
provider "aws" {
  region = var.aws_region
}

# Variables with defaults
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "delivery_stream_name" {
  description = "Name for the Kinesis Firehose Delivery Stream"
  type        = string
  default     = "opensearch-serverless-firehose"
}

variable "index_name" {
  description = "The target OpenSearch index name"
  type        = string
  default     = "my-index"
}

variable "collection_name" {
  description = "The OpenSearch Serverless collection name"
  type        = string
  default     = "my-collection"
}

variable "backup_bucket_name" {
  description = "The name of the S3 bucket used for Firehose backup"
  type        = string
  default     = "firehose-backup-bucket-unique-123456"  # Ensure globally unique bucket name.
}

variable "backup_buffer_interval" {
  description = "S3 backup buffering interval in seconds"
  type        = number
  default     = 300
}

variable "backup_buffer_size" {
  description = "S3 backup buffering size in MB"
  type        = number
  default     = 5
}

# Create an S3 bucket for backup for failed documents
resource "aws_s3_bucket" "firehose_backup" {
  bucket = var.backup_bucket_name

  acl    = "private"

  tags = {
    Name        = "FirehoseBackupBucket"
    Environment = "dev"
  }
}

# Create an OpenSearch Serverless Collection.
resource "aws_opensearchserverless_collection" "example" {
  name        = var.collection_name
  type        = "SEARCH"  # Using SEARCH type for indexing/queries
  description = "OpenSearch Serverless Collection for Firehose destination"

  tags = {
    Environment = "dev"
  }
}

# Create an IAM role for Kinesis Firehose.
resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach an inline policy to the Firehose role with required permissions.
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_delivery_policy"
  role   = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowOpenSearchServerlessAccess"
        Effect   = "Allow"
        Action   = [
          "aoss:APIAccessAll",
          "opensearchserverless:DescribeCollection",
          "opensearchserverless:ListCollections"
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowS3AccessForBackup"
        Effect   = "Allow"
        Action   = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.firehose_backup.arn,
          "${aws_s3_bucket.firehose_backup.arn}/*"
        ]
      }
    ]
  })
}

# Create the Kinesis Firehose Delivery Stream with OpenSearch Serverless destination.
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name = var.delivery_stream_name
  destination = "opensearch"

  # Using the OpenSearch Serverless Destination configuration.
  opensearch_serverless_destination_configuration {
    role_arn          = aws_iam_role.firehose_role.arn
    index_name        = var.index_name
    collection_endpoint = aws_opensearchserverless_collection.example.endpoint
    s3_backup_mode    = "FailedDocumentsOnly"

    # S3 backup configuration for failed documents.
    s3_configuration {
      role_arn        = aws_iam_role.firehose_role.arn
      bucket_arn      = aws_s3_bucket.firehose_backup.arn
      buffering_interval = var.backup_buffer_interval
      buffering_size     = var.backup_buffer_size

      compression_format = "GZIP"
    }

    # Optionally disable document transformation processing (set to false).
    processing_configuration {
      enabled = false
    }
  }
}
  
output "firehose_delivery_stream_name" {
  description = "The name of the Kinesis Firehose Delivery Stream"
  value       = aws_kinesis_firehose_delivery_stream.firehose_stream.name
}

output "opensearch_collection_endpoint" {
  description = "Endpoint of the OpenSearch Serverless Collection"
  value       = aws_opensearchserverless_collection.example.endpoint
}
</iac_template>