I'll help you create a Terraform configuration to deploy an Amazon MSK (Managed Streaming for Apache Kafka) cluster with logging enabled to an S3 bucket in the us-east-1 region. The configuration will include:

1. An S3 bucket for MSK logs
2. Required IAM roles and policies for MSK logging
3. A VPC with necessary subnets for the MSK cluster
4. Security groups for the MSK cluster
5. The MSK cluster itself with logging configuration

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "cluster_name" {
  description = "Name of the MSK cluster"
  default     = "my-msk-cluster"
}

variable "kafka_version" {
  description = "Version of Apache Kafka"
  default     = "2.8.1"
}

# VPC Configuration
resource "aws_vpc" "msk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

# Create 3 private subnets in different AZs
resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "msk-private-subnet-${count.index + 1}"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# S3 bucket for MSK logs
resource "aws_s3_bucket" "msk_logs" {
  bucket = "msk-logs-${random_string.random.result}"
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# MSK Security Group
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

# IAM role for MSK logging
resource "aws_iam_role" "msk_logging_role" {
  name = "msk-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kafka.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for MSK logging
resource "aws_iam_role_policy" "msk_logging_policy" {
  name = "msk-logging-policy"
  role = aws_iam_role.msk_logging_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.msk_logs.arn,
          "${aws_s3_bucket.msk_logs.arn}/*"
        ]
      }
    ]
  })
}

# MSK Cluster
resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version         = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = aws_subnet.private_subnet[*].id
    security_groups = [aws_security_group.msk_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  logging_info {
    broker_logs {
      s3 {
        enabled = true
        bucket  = aws_s3_bucket.msk_logs.id
        prefix  = "msk-logs/"
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  tags = {
    Environment = "Production"
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
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.msk_rt.id
}
</iac_template>

This Terraform configuration creates:

1. A VPC with three private subnets across different availability zones
2. An S3 bucket with a random suffix for storing MSK logs
3. A security group allowing Kafka traffic (port 9092) within the VPC
4. IAM roles and policies for MSK logging to S3
5. An MSK cluster with:
   - 3 broker nodes
   - TLS encryption in transit
   - Logging enabled to S3
   - t3.small instances (can be modified as needed)
   - 100GB EBS storage per broker

The configuration includes all necessary networking components and security settings. The MSK cluster will be created in the private subnets with proper security groups and logging enabled to the S3 bucket.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Make sure you have proper AWS credentials configured before applying this configuration.