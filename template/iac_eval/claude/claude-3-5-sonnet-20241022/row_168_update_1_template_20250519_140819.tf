provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_id" {
  description = "VPC ID where DAX cluster will be deployed"
  default     = "vpc-0123456789abcdef0" # Replace with your VPC ID
}

variable "subnet_ids" {
  description = "Subnet IDs for DAX cluster"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0"] # Replace with your subnet ID
}

# IAM Role for DAX
resource "aws_iam_role" "dax_role" {
  name = "dax-cluster-role"

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
  name = "dax-cluster-policy"
  role = aws_iam_role.dax_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Security Group for DAX
resource "aws_security_group" "dax_sg" {
  name        = "dax-cluster-sg"
  description = "Security group for DAX cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8111
    to_port     = 8111
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
    Name = "dax-cluster-sg"
  }
}

# DAX Subnet Group
resource "aws_dax_subnet_group" "dax_subnet_group" {
  name       = "dax-subnet-group"
  subnet_ids = var.subnet_ids
}

# DAX Parameter Group
resource "aws_dax_parameter_group" "dax_parameter_group" {
  name = "dax-parameter-group"

  parameters {
    name  = "query-ttl-millis"
    value = "100000"
  }

  parameters {
    name  = "record-ttl-millis"
    value = "100000"
  }
}

# DAX Cluster
resource "aws_dax_cluster" "dax_cluster" {
  cluster_name       = "dax-cluster"
  iam_role_arn      = aws_iam_role.dax_role.arn
  node_type         = "dax.r4.large"
  replication_factor = 1
  subnet_group_name = aws_dax_subnet_group.dax_subnet_group.name
  parameter_group_name = aws_dax_parameter_group.dax_parameter_group.name
  security_group_ids  = [aws_security_group.dax_sg.id]

  tags = {
    Name = "dax-cluster"
  }
}