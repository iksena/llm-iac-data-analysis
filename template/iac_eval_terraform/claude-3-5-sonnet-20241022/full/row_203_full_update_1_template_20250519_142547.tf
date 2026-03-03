I'll help you create a Terraform configuration to deploy an Amazon MSK (Managed Streaming for Apache Kafka) cluster with CloudWatch logging enabled in the us-east-1 region. The configuration will include:

1. An MSK cluster with 2 broker nodes
2. CloudWatch log group for MSK logging
3. IAM role and policy for MSK to CloudWatch logging
4. Necessary security group for MSK cluster
5. Required VPC networking components

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
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

resource "aws_subnet" "msk_subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "msk-subnet-1"
  }
}

resource "aws_subnet" "msk_subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "msk-subnet-2"
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
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "msk_log_group" {
  name              = "/aws/msk/cluster"
  retention_in_days = 30
}

# IAM Role for MSK
resource "aws_iam_role" "msk_role" {
  name = "msk-cloudwatch-role"

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

# IAM Policy for MSK CloudWatch logging
resource "aws_iam_role_policy" "msk_cloudwatch_policy" {
  name = "msk-cloudwatch-policy"
  role = aws_iam_role.msk_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# MSK Cluster
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = [aws_subnet.msk_subnet_1.id, aws_subnet.msk_subnet_2.id]
    security_groups = [aws_security_group.msk_sg.id]

    storage_info {
      ebs_storage_info {
        volume_size = 100
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_log_group.name
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
    Environment = "production"
  }
}
</iac_template>

This Terraform configuration creates a fully functional MSK cluster with CloudWatch logging enabled. Here's what each component does:

1. Creates a VPC with two subnets in different availability zones
2. Sets up a security group allowing Kafka traffic (port 9092)
3. Creates a CloudWatch log group for MSK logs
4. Sets up IAM role and policy for MSK to CloudWatch logging
5. Deploys an MSK cluster with:
   - 2 broker nodes
   - Kafka version 2.8.1
   - t3.small instance type
   - 100GB EBS storage per broker
   - TLS encryption in transit
   - CloudWatch logging enabled

The configuration is complete and deployable. All necessary resources are declared and properly referenced. The MSK cluster will be created in the us-east-1 region with proper networking and security configurations.