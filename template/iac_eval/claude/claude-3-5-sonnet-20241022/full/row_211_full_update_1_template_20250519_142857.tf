I'll help you create a serverless Amazon MSK (Managed Streaming for Apache Kafka) cluster in the us-east-2 region. This configuration will include:

1. A VPC with private subnets for the MSK cluster
2. Security group for MSK
3. Serverless MSK cluster configuration
4. Required IAM role and policy
5. Necessary networking components (route tables, internet gateway)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-2"
}

# Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

# VPC
resource "aws_vpc" "msk_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "msk-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "msk-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "msk-private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "msk-private-subnet-3"
  }
}

# Security Group
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "msk-security-group"
  }
}

# IAM Role
resource "aws_iam_role" "msk_role" {
  name = "msk-serverless-role"

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

# MSK Serverless Cluster
resource "aws_msk_serverless_cluster" "msk_serverless" {
  cluster_name = "msk-serverless-cluster"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
      aws_subnet.private_subnet_3.id
    ]
    security_group_ids = [aws_security_group.msk_sg.id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  tags = {
    Name = "msk-serverless-cluster"
  }
}

# Output
output "msk_cluster_arn" {
  value = aws_msk_serverless_cluster.msk_serverless.arn
}
</iac_template>

This Terraform configuration creates a serverless MSK cluster with the following components:

1. A VPC with CIDR block 10.0.0.0/16
2. Three private subnets in different availability zones
3. Security group allowing inbound traffic on port 9098 (MSK)
4. IAM role for MSK service
5. Serverless MSK cluster with IAM authentication enabled
6. Internet Gateway for VPC connectivity

The MSK cluster is configured with:
- IAM authentication for security
- Three private subnets for high availability
- Appropriate security group rules
- Serverless configuration for automatic scaling

The configuration outputs the ARN of the created MSK cluster. To use this cluster, you'll need to ensure that your client applications have the appropriate IAM permissions to interact with the cluster and are deployed within the same VPC or have proper VPC connectivity set up.