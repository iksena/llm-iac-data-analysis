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