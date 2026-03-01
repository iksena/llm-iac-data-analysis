provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "collection_name" {
  description = "Name of the OpenSearch Serverless collection"
  default     = "my-collection"
}

variable "firehose_name" {
  description = "Name of the Kinesis Firehose Delivery Stream"
  default     = "my-firehose-stream"
}

# OpenSearch Serverless Collection
resource "aws_opensearchserverless_collection" "example" {
  name = var.collection_name
}

# OpenSearch Security Policy
resource "aws_opensearchserverless_security_policy" "example" {
  name = "example-security-policy"
  type = "encryption"
  policy = jsonencode({
    Rules = [
      {
        Resource = ["collection/${aws_opensearchserverless_collection.example.name}"],
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

# OpenSearch Access Policy
resource "aws_opensearchserverless_access_policy" "example" {
  name = "example-access-policy"
  type = "data"
  policy = jsonencode({
    Rules = [
      {
        Resource = ["collection/${aws_opensearchserverless_collection.example.name}"],
        Permission = ["aoss:*"],
        ResourceType = "collection"
      }
    ],
    Principal = [
      {
        AWS = ["*"]
      }
    ]
  })
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose-role"

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
          "aoss:APIAccessAll",
          "aoss:BatchGetCollection",
          "aoss:CreateCollection",
          "aoss:DeleteCollection"
        ]
        Resource = aws_opensearchserverless_collection.example.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ]
        Resource = "*"
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = var.firehose_name
  destination = "opensearchserverless"

  opensearchserverless_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    collection_endpoint = aws_opensearchserverless_collection.example.collection_endpoint
    index_name = "test-index"

    buffering_interval = 60
    buffering_size    = 5

    retry_duration = 300

    s3_backup_mode = "FailedDocumentsOnly"

    s3_configuration {
      role_arn   = aws_iam_role.firehose_role.arn
      bucket_arn = aws_s3_bucket.backup.arn
    }
  }

  depends_on = [
    aws_opensearchserverless_collection.example,
    aws_opensearchserverless_security_policy.example,
    aws_opensearchserverless_access_policy.example
  ]
}

# S3 Bucket for backup
resource "aws_s3_bucket" "backup" {
  bucket = "my-firehose-backup-bucket-${random_string.suffix.result}"
}

# Random string for unique S3 bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "backup" {
  bucket = aws_s3_bucket.backup.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.firehose_role.arn
        }
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.backup.arn,
          "${aws_s3_bucket.backup.arn}/*"
        ]
      }
    ]
  })
}