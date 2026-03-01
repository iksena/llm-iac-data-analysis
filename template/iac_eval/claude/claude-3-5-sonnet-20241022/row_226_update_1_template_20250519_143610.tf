provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the DAX cluster"
  default     = "my-dax-cluster"
}

variable "node_type" {
  description = "Node type for DAX cluster"
  default     = "dax.t3.small"
}

# VPC Data Source (assuming default VPC)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# IAM Role for DAX
resource "aws_iam_role" "dax_role" {
  name = "dax-role"

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

# IAM Policy for DAX
resource "aws_iam_role_policy" "dax_policy" {
  name = "dax-policy"
  role = aws_iam_role.dax_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Security Group for DAX
resource "aws_security_group" "dax" {
  name        = "dax-security-group"
  description = "Security group for DAX cluster"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8111
    to_port     = 8111
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
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

# DAX Subnet Group
resource "aws_dax_subnet_group" "dax" {
  name       = "dax-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

# DAX Cluster
resource "aws_dax_cluster" "dax" {
  cluster_name       = var.cluster_name
  iam_role_arn      = aws_iam_role.dax_role.arn
  node_type         = var.node_type
  replication_factor = 3
  subnet_group_name = aws_dax_subnet_group.dax.name
  security_group_ids = [aws_security_group.dax.id]

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}