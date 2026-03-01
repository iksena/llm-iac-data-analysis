I'll help you create a Terraform configuration to deploy an Amazon DynamoDB Accelerator (DAX) cluster using dax.r4.large node type with a replication factor of 1. This configuration will include necessary IAM roles and security group for the DAX cluster.

Description:
- Creates an IAM role and policy for DAX cluster
- Creates a security group for DAX cluster
- Deploys a DAX cluster with dax.r4.large node type
- Sets replication factor to 1
- Configures necessary subnet group for DAX

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for DAX
resource "aws_iam_role" "dax_role" {
  name = "dax-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dax.amazonaws.com"
        }
      }
    ]
  })
}

# Attach DAX policy to role
resource "aws_iam_role_policy" "dax_policy" {
  name = "dax-service-policy"
  role = aws_iam_role.dax_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create security group for DAX
resource "aws_security_group" "dax_sg" {
  name        = "dax-security-group"
  description = "Security group for DAX cluster"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8111
    to_port     = 8111
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dax-security-group"
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dax-vpc"
  }
}

# Create subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dax-subnet"
  }
}

# Create DAX subnet group
resource "aws_dax_subnet_group" "main" {
  name       = "dax-subnet-group"
  subnet_ids = [aws_subnet.main.id]
}

# Create DAX cluster
resource "aws_dax_cluster" "main" {
  cluster_name       = "dax-cluster"
  iam_role_arn      = aws_iam_role.dax_role.arn
  node_type         = "dax.r4.large"
  replication_factor = 1
  subnet_group_name = aws_dax_subnet_group.main.name
  security_group_ids = [aws_security_group.dax_sg.id]

  tags = {
    Name = "dax-cluster"
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with a subnet for the DAX cluster
2. An IAM role with necessary permissions for DAX
3. A security group allowing DAX traffic (port 8111)
4. A DAX subnet group
5. A DAX cluster with the specified configuration (dax.r4.large node type and replication factor of 1)

Note: Make sure you have appropriate AWS credentials configured to deploy this infrastructure. Also, be aware that DAX clusters can incur significant costs, so remember to destroy the resources when they're no longer needed.