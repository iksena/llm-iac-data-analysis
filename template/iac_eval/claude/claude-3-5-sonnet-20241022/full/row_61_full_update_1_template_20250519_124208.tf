I'll help you create a Terraform configuration for an AWS Kinesis Firehose Delivery Stream that delivers data to Amazon Elasticsearch Service (now called OpenSearch). The configuration will include:

1. A Kinesis Firehose Delivery Stream
2. An Elasticsearch/OpenSearch domain as the destination
3. An S3 bucket for backup and failed records
4. Required IAM roles and policies for Firehose to interact with Elasticsearch and S3
5. Required security group for Elasticsearch domain

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment" {
  description = "Environment name"
  default     = "prod"
}

variable "app_name" {
  description = "Application name"
  default     = "data-stream"
}

# S3 bucket for backup and failed records
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "${var.app_name}-${var.environment}-firehose-backup"
}

resource "aws_s3_bucket_acl" "firehose_bucket_acl" {
  bucket = aws_s3_bucket.firehose_bucket.id
  acl    = "private"
}

# Elasticsearch Domain
resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.app_name}-${var.environment}"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  vpc_options {
    subnet_ids = [aws_default_subnet.default.id]
    security_group_ids = [aws_security_group.es_sg.id]
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.firehose_role.arn}"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.app_name}-${var.environment}/*"
    }
  ]
}
CONFIG
}

# Default VPC and Subnet
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default" {
  availability_zone = "${data.aws_region.current.name}a"
}

# Security Group for Elasticsearch
resource "aws_security_group" "es_sg" {
  name        = "${var.app_name}-${var.environment}-es-sg"
  description = "Security group for Elasticsearch domain"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
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
          aws_s3_bucket.firehose_bucket.arn,
          "${aws_s3_bucket.firehose_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut"
        ]
        Resource = [
          aws_elasticsearch_domain.es.arn,
          "${aws_elasticsearch_domain.es.arn}/*"
        ]
      }
    ]
  })
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "es_stream" {
  name        = "${var.app_name}-${var.environment}-stream"
  destination = "elasticsearch"

  elasticsearch_configuration {
    domain_arn = aws_elasticsearch_domain.es.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "test-index"
    type_name  = "test-type"
    
    buffering_interval = 60
    buffering_size    = 5

    s3_backup_mode = "FailedDocumentsOnly"
  }

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.firehose_bucket.arn
    
    buffering_size     = 5
    buffering_interval = 60
    compression_format = "GZIP"
  }
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
</iac_template>

This Terraform configuration creates:

1. An S3 bucket for backup and failed records storage
2. An Elasticsearch domain in a VPC with appropriate security group
3. IAM role and policy for Kinesis Firehose to access both Elasticsearch and S3
4. A Kinesis Firehose Delivery Stream configured to deliver data to Elasticsearch
5. Necessary networking components (VPC, subnet, security group)

The configuration uses the default VPC and creates a subnet in the first availability zone. The Elasticsearch domain is deployed in VPC for better security. The Firehose delivery stream is configured to:
- Buffer data for 60 seconds or 5 MB (whichever comes first)
- Use GZIP compression for S3 backup
- Only backup failed documents to S3
- Write to an index named "test-index" in Elasticsearch

You can customize the variables (environment and app_name) to match your needs. The configuration uses t3.small.elasticsearch instance type, which you might want to adjust based on your requirements.