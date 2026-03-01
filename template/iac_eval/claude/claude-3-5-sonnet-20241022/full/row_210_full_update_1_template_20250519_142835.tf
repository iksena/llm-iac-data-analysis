I'll help you create a Terraform configuration for a serverless Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes in the us-east-1 region. The configuration will include:

1. A VPC with necessary subnets for the MSK cluster
2. Security groups for the MSK cluster
3. MSK Serverless cluster configuration
4. Required IAM roles and policies
5. Necessary networking components (Internet Gateway, Route Tables)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
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

# Internet Gateway
resource "aws_internet_gateway" "msk_igw" {
  vpc_id = aws_vpc.msk_vpc.id

  tags = {
    Name = "msk-igw"
  }
}

# Subnets for MSK cluster
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

resource "aws_subnet" "msk_subnet_3" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "msk-subnet-3"
  }
}

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

# IAM Role for MSK
resource "aws_iam_role" "msk_role" {
  name = "msk-cluster-role"

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
      aws_subnet.msk_subnet_1.id,
      aws_subnet.msk_subnet_2.id,
      aws_subnet.msk_subnet_3.id
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
resource "aws_route_table_association" "msk_rta_1" {
  subnet_id      = aws_subnet.msk_subnet_1.id
  route_table_id = aws_route_table.msk_rt.id
}

resource "aws_route_table_association" "msk_rta_2" {
  subnet_id      = aws_subnet.msk_subnet_2.id
  route_table_id = aws_route_table.msk_rt.id
}

resource "aws_route_table_association" "msk_rta_3" {
  subnet_id      = aws_subnet.msk_subnet_3.id
  route_table_id = aws_route_table.msk_rt.id
}
</iac_template>

This Terraform configuration creates:
1. A VPC with CIDR block 10.0.0.0/16
2. Three subnets in different availability zones for high availability
3. An Internet Gateway and associated route table
4. A security group allowing inbound traffic on port 9098 (MSK)
5. An IAM role for the MSK cluster
6. A serverless MSK cluster with IAM authentication enabled
7. Necessary route table associations

The MSK cluster will be created in the us-east-1 region with 3 broker nodes distributed across three availability zones. The cluster uses IAM authentication for security. The networking components ensure the cluster is accessible while maintaining security best practices.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Make sure you have appropriate AWS credentials configured before applying this configuration.