provider "aws" {
  region = "us-east-1"
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# OpenSearch Domain
resource "aws_opensearch_domain" "example" {
  domain_name = "domain-${random_string.suffix.result}"
  
  cluster_config {
    instance_type = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  engine_version = "OpenSearch_2.5"
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
          "es:*"
        ]
        Resource = [
          aws_opensearch_domain.example.arn,
          "${aws_opensearch_domain.example.arn}/*"
        ]
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

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "firehose" {
  name = "/aws/firehose/elasticsearch-delivery"
  retention_in_days = 14
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "firehose" {
  name           = "ElasticsearchDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose.name
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "firehose-stream-${random_string.suffix.result}"
  destination = "elasticsearch"

  server_side_encryption {
    enabled = true
  }

  elasticsearch_configuration {
    domain_arn = aws_opensearch_domain.example.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "test-index"

    buffering_interval = 60
    buffering_size    = 5

    retry_duration = 300

    s3_backup_mode = "FailedDocumentsOnly"

    cloudwatch_logging_options {
      enabled = true
      log_group_name = aws_cloudwatch_log_group.firehose.name
      log_stream_name = aws_cloudwatch_log_stream.firehose.name
    }
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.backup.arn
    compression_format = "GZIP"
  }

  depends_on = [
    aws_opensearch_domain.example,
    aws_iam_role_policy.firehose_policy,
    aws_s3_bucket.backup,
    aws_cloudwatch_log_group.firehose,
    aws_cloudwatch_log_stream.firehose
  ]
}

# Output values
output "opensearch_endpoint" {
  value = aws_opensearch_domain.example.endpoint
}

output "firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.example.name
}