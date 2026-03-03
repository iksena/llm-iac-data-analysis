provider "aws" {
  region = "us-east-1"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# OpenSearch Serverless Collection
resource "aws_opensearchserverless_collection" "example" {
  name = "collection-${random_string.suffix.result}"
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose-role-${random_string.suffix.result}"

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
  name = "firehose-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aoss:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      }
    ]
  })
}

# S3 Bucket for backup
resource "aws_s3_bucket" "backup" {
  bucket = "firehose-backup-${random_string.suffix.result}"
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "firehose-stream-${random_string.suffix.result}"
  destination = "amazonopensearchserverless"

  server_side_encryption {
    enabled = true
  }

  amazon_opensearch_serverless_destination_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    collection_endpoint = aws_opensearchserverless_collection.example.collection_endpoint
    index_name         = "test-index"

    buffering_interval = 60
    buffering_size    = 5

    retry_duration = 300

    s3_backup_mode = "FailedDocumentsOnly"

    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = aws_s3_bucket.backup.arn

      buffering_size     = 10
      buffering_interval = 400
      compression_format = "GZIP"
    }
  }

  depends_on = [
    aws_opensearchserverless_collection.example,
    aws_iam_role_policy.firehose_policy,
    aws_s3_bucket.backup
  ]
}

# Output values
output "collection_endpoint" {
  value = aws_opensearchserverless_collection.example.collection_endpoint
}

output "firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.example.name
}