provider "aws" {
  region = "us-west-2"
}

# VPC Configuration
resource "aws_vpc" "sagemaker_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sagemaker-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.sagemaker_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "sagemaker-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.sagemaker_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "sagemaker-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.sagemaker_vpc.id

  tags = {
    Name = "sagemaker-igw"
  }
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-domain-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# SageMaker Domain
resource "aws_sagemaker_domain" "main" {
  domain_name = "sagemaker-domain"
  auth_mode   = "IAM"
  vpc_id      = aws_vpc.sagemaker_vpc.id
  subnet_ids  = [aws_subnet.private.id]

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }

  default_space_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }
}

# Variables with default values
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "tags" {
  description = "Default tags for resources"
  type        = map(string)
  default = {
    Environment = "development"
    Terraform   = "true"
  }
}