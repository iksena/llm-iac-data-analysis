I'll help you create a Terraform configuration that sets up an Amazon MSK (Managed Streaming for Apache Kafka) cluster with CloudWatch logging, S3 bucket, and Kinesis Firehose integration. Here's what the configuration will include:

1. MSK cluster with 3 broker nodes
2. CloudWatch log group for MSK logs
3. S3 bucket for data storage
4. Kinesis Firehose delivery stream
5. Necessary IAM roles and policies
6. Encryption at rest using AWS KMS
7. MSK open monitoring enabled

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "cluster_name" {
  default = "msk-cluster"
}

variable "kafka_version" {
  default = "2.8.1"
}

variable "broker_instance_type" {
  default = "kafka.t3.small"
}

# VPC and Subnet data sources (assuming existing VPC)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# KMS key for encryption at rest
resource "aws_kms_key" "msk_key" {
  description = "KMS key for MSK cluster encryption"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/${var.cluster_name}"
  retention_in_days = 7
}

# S3 bucket
resource "aws_s3_bucket" "msk_bucket" {
  bucket = "msk-data-bucket-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "msk_bucket_versioning" {
  bucket = aws_s3_bucket.msk_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "msk-firehose-role"

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

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = var.broker_instance_type
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

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
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

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "msk_firehose" {
  name        = "msk-firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.msk_bucket.arn
    prefix     = "msk-data/"
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }
}

# Outputs
output "msk_brokers" {
  value = aws_msk_cluster.kafka_cluster.bootstrap_brokers
}

output "s3_bucket_name" {
  value = aws_s3_bucket.msk_bucket.id
}

output "firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.msk_firehose.name
}
</iac_template>

This Terraform configuration creates:
1. An MSK cluster with 3 broker nodes
2. KMS key for encryption at rest
3. CloudWatch log group for MSK logs
4. S3 bucket with versioning enabled
5. Kinesis Firehose delivery stream writing to the S3 bucket
6. Required IAM roles and policies
7. Security group for MSK cluster
8. Enables open monitoring with Prometheus JMX and Node exporters

The configuration uses the default VPC and its subnets. If you need to use a specific VPC, you should modify the data sources accordingly.

Note that:
- The MSK cluster uses kafka.t3.small instances by default
- The broker EBS volume size is set to 100GB
- CloudWatch logs retention is set to 7 days
- Firehose buffer size is 5MB with a 300-second interval
- The S3 bucket name will be unique due to the random string suffix
- Security group allows inbound traffic on port 9092 from anywhere (you might want to restrict this in production)

Remember to:
1. Ensure you have appropriate AWS credentials configured
2. Check that you have at least 3 subnets in your VPC
3. Adjust the security group rules according to your security requirements
4. Modify the instance type and storage size based on your needs