I'll help you create a Terraform configuration to deploy an Amazon MSK (Managed Streaming for Apache Kafka) cluster with logging enabled to Kinesis Firehose in the us-east-1 region. The configuration will include:

1. An MSK cluster with necessary networking components (VPC, subnets, security groups)
2. A Kinesis Firehose delivery stream
3. IAM roles and policies for MSK logging to Firehose
4. MSK configuration for broker logging

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "cluster_name" {
  default = "msk-cluster"
}

variable "kafka_version" {
  default = "2.8.1"
}

# VPC and Networking
resource "aws_vpc" "msk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "msk-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "msk-subnet-2"
  }
}

resource "aws_subnet" "subnet_3" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "msk-subnet-3"
  }
}

# Security Group
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.msk_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for Firehose
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

# IAM Role Policy for Firehose
resource "aws_iam_role_policy" "firehose_policy" {
  name = "msk-firehose-policy"
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
          aws_s3_bucket.logs_bucket.arn,
          "${aws_s3_bucket.logs_bucket.arn}/*"
        ]
      }
    ]
  })
}

# S3 Bucket for Firehose
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "msk-logs-bucket-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "msk_logs" {
  name        = "msk-logs-firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.logs_bucket.arn
    prefix     = "msk-logs/"
  }
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = var.cluster_name
  kafka_version         = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets = [
      aws_subnet.subnet_1.id,
      aws_subnet.subnet_2.id,
      aws_subnet.subnet_3.id
    ]
    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
    security_groups = [aws_security_group.msk_sg.id]
  }

  logging_info {
    broker_logs {
      firehose {
        enabled         = true
        delivery_stream = aws_kinesis_firehose_delivery_stream.msk_logs.name
      }
    }
  }
}

# Internet Gateway
resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

# Route Table
resource "aws_route_table" "msk_rt" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }

  tags = {
    Name = "msk-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "subnet_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.msk_rt.id
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.msk_rt.id
}

resource "aws_route_table_association" "subnet_3" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.msk_rt.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with three subnets across different availability zones
2. Security groups for the MSK cluster
3. An S3 bucket to store the logs
4. A Kinesis Firehose delivery stream
5. Necessary IAM roles and policies
6. An MSK cluster with broker logging enabled to Kinesis Firehose
7. Required networking components (Internet Gateway, Route Table)

The MSK cluster is configured with:
- 3 broker nodes
- t3.small instance type
- 100GB EBS storage per broker
- Kafka version 2.8.1
- Broker logging enabled and configured to send logs to Kinesis Firehose

The configuration includes all necessary networking components to make the cluster accessible within the VPC. The Kinesis Firehose is configured to deliver the logs to an S3 bucket with appropriate permissions.