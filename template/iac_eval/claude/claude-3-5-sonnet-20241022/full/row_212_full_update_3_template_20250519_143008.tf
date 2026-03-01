I'll provide a cleaner, properly formatted version with the template tags as requested. Here's the improved version:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/msk-cluster-${random_string.suffix.result}"
  retention_in_days = 7
}

# S3 bucket
resource "aws_s3_bucket" "msk_bucket" {
  bucket = "msk-data-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_versioning" "msk_bucket_versioning" {
  bucket = aws_s3_bucket.msk_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# VPC and Subnet data sources
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name_prefix = "msk-sg-"
  description = "Security group for MSK cluster"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# KMS key for encryption at rest
resource "aws_kms_key" "msk_key" {
  description             = "KMS key for MSK cluster encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster-${random_string.suffix.result}"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = slice(data.aws_subnets.default.ids, 0, 3)
    security_groups = [aws_security_group.msk_sg.id]
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk_key.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    cloudwatch_logs {
      enabled   = true
      log_group = aws_cloudwatch_log_group.msk_log_group.name
    }
  }
}

# IAM role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "msk-firehose-role-${random_string.suffix.result}"

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

# IAM policy for Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "msk-firehose-policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.msk_bucket.arn,
          "${aws_s3_bucket.msk_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "msk_firehose" {
  name        = "msk-firehose-${random_string.suffix.result}"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.msk_bucket.arn
    prefix             = "msk-data/"
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }
}

output "msk_brokers" {
  description = "MSK Cluster Brokers"
  value       = aws_msk_cluster.kafka_cluster.bootstrap_brokers
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.msk_bucket.id
}

output "firehose_name" {
  description = "Kinesis Firehose Stream Name"
  value       = aws_kinesis_firehose_delivery_stream.msk_firehose.name
}
</iac_template>

This improved version includes:
1. Proper terraform block with required providers
2. Removed variables and simplified the configuration
3. Added random string suffix to ensure unique resource names
4. Properly formatted and structured code
5. Removed unnecessary configurations
6. Enclosed in iac_template tags as requested
7. Maintained all core functionality (MSK cluster with 3 brokers, CloudWatch logging, S3 bucket, and Kinesis Firehose)
8. Kept encryption at rest and open monitoring features

The template should now be syntactically correct and deployable in AWS.