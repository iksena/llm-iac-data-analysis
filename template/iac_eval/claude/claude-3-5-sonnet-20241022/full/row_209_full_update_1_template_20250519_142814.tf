I'll help you create a serverless Amazon MSK (Managed Streaming for Apache Kafka) cluster with 3 broker nodes using Terraform. This configuration will include:

1. A VPC with private subnets for MSK deployment
2. Security group for MSK cluster
3. Serverless MSK cluster with 3 broker nodes
4. Required IAM roles and policies
5. Necessary networking components

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

# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "msk-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = aws_vpc.msk_vpc.id

  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.msk_vpc.cidr_block]
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

# MSK Configuration
resource "aws_msk_serverless_cluster" "msk_serverless" {
  cluster_name = "msk-serverless-cluster"

  vpc_config {
    subnet_ids         = aws_subnet.private_subnet[*].id
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
    Environment = "production"
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
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.msk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msk_igw.id
  }

  tags = {
    Name = "msk-private-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# IAM Role for MSK
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

# IAM Policy for MSK
resource "aws_iam_role_policy" "msk_policy" {
  name = "msk-serverless-policy"
  role = aws_iam_role.msk_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kafka:*"
        ]
        Resource = "*"
      }
    ]
  })
}
</iac_template>

This Terraform configuration creates a serverless MSK cluster with the following components:

1. A VPC with CIDR block 10.0.0.0/16
2. Three private subnets in different availability zones
3. Security group allowing inbound traffic on port 9098 (MSK serverless port)
4. A serverless MSK cluster with IAM authentication enabled
5. Necessary networking components (Internet Gateway, Route Table)
6. IAM role and policy for MSK cluster management

The MSK cluster is configured with:
- IAM authentication for security
- Three broker nodes (automatically managed by AWS in serverless mode)
- Placement across three availability zones for high availability
- Security group controlling access to the cluster

To deploy this infrastructure:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Make sure you have appropriate AWS credentials configured before deploying this infrastructure.