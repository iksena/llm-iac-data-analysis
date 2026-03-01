I'll help you create a Terraform configuration that sets up an AWS Kinesis Firehose Delivery Stream with a Redshift cluster as the destination. This configuration will:

1. Create a VPC with necessary networking components for Redshift
2. Create a Redshift cluster
3. Create an IAM role for Firehose
4. Create an S3 bucket for intermediate storage
5. Create the Kinesis Firehose Delivery Stream pointing to Redshift
6. Set up necessary security groups

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "environment" {
  default = "prod"
}

variable "redshift_database_name" {
  default = "analytics"
}

variable "redshift_master_username" {
  default = "admin"
}

variable "redshift_master_password" {
  default = "Admin123456789"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "redshift-vpc"
  }
}

resource "aws_subnet" "primary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "redshift-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "redshift-igw"
  }
}

# Security Group for Redshift
resource "aws_security_group" "redshift" {
  name        = "redshift-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# S3 bucket for Firehose intermediate storage
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "firehose-intermediate-${var.environment}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# IAM role for Firehose
resource "aws_iam_role" "firehose_role" {
  name = "firehose-redshift-role"

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
  name = "firehose-policy"
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
          "redshift:DescribeClusters",
          "redshift:GetClusterCredentials",
          "redshift:Connect"
        ]
        Resource = [
          aws_redshift_cluster.main.arn
        ]
      }
    ]
  })
}

# Redshift Cluster
resource "aws_redshift_cluster" "main" {
  cluster_identifier  = "redshift-cluster"
  database_name      = var.redshift_database_name
  master_username    = var.redshift_master_username
  master_password    = var.redshift_master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.redshift.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.main.name
}

resource "aws_redshift_subnet_group" "main" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.primary.id]
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "main" {
  name        = "redshift-stream"
  destination = "redshift"

  redshift_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    cluster_jdbcurl    = "jdbc:redshift://${aws_redshift_cluster.main.endpoint}/${var.redshift_database_name}"
    username           = var.redshift_master_username
    password           = var.redshift_master_password
    data_table_name    = "your_table_name"
    copy_options       = "JSON 'auto'"
    
    s3_backup_mode = "Enabled"
    
    s3_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = aws_s3_bucket.firehose_bucket.arn
      buffer_size        = 5
      buffer_interval    = 300
      compression_format = "GZIP"
    }
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with necessary networking components
2. A security group for Redshift access
3. An S3 bucket for Firehose's intermediate storage
4. IAM roles and policies for Firehose to access S3 and Redshift
5. A single-node Redshift cluster
6. A Kinesis Firehose Delivery Stream configured to deliver data to the Redshift cluster

To use this configuration:
1. Make sure you have AWS credentials configured
2. Adjust the variables as needed (especially the Redshift password)
3. Update the region if needed
4. Make sure to replace "your_table_name" in the Firehose configuration with your actual Redshift table name

Note: This is a basic configuration and might need additional security hardening for production use, such as:
- More restricted security group rules
- VPC endpoints for enhanced security
- Encryption configuration
- More complex networking setup
- Additional backup configurations