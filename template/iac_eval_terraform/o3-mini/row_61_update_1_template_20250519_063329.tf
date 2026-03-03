terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Generate a random suffix for unique S3 bucket name.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# S3 bucket for Firehose backup
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "firehose-backup-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }
  
  tags = {
    Name = "Firehose Backup Bucket"
  }
}

# Elasticsearch domain required for the destination
resource "aws_elasticsearch_domain" "es" {
  domain_name = "firehose-es-domain"

  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  # In a production environment, you would likely adjust access policies here.
  access_policies = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "*" },
        "Action" : "es:*",
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Domain = "FirehoseES"
  }
}

# CloudWatch Log Group for Firehose logging
resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name              = "firehose-log-group"
  retention_in_days = 7
}

# IAM Role for Firehose with trust for firehose.amazonaws.com
resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_stream_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Role Policy for Firehose access to S3 and Elasticsearch
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose_delivery_policy"
  role   = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.firehose_bucket.arn,
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpGet",
          "es:ESHttpDelete"
        ],
        Resource = "${aws_elasticsearch_domain.es.arn}/*"
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream with an Elasticsearch destination.
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name = "firehose-stream"

  elasticsearch_destination_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    domain_arn         = aws_elasticsearch_domain.es.arn
    index_name         = "firehose-index"
    type_name          = "_doc"
    index_rotation_period = "NoRotation"

    buffering_interval = 300
    buffering_size     = 5
    retry_duration     = 300

    s3_configuration {
      role_arn            = aws_iam_role.firehose_role.arn
      bucket_arn          = aws_s3_bucket.firehose_bucket.arn
      buffering_interval  = 300
      buffering_size      = 5
      compression_format  = "UNCOMPRESSED"
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = "firehose-logs-stream"
    }
  }
}