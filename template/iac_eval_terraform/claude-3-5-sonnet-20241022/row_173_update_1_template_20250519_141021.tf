provider "aws" {
  region = "us-west-2"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker-execution-role"

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

# Attach AmazonSageMakerFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_policy" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Get AWS account ID
data "aws_caller_identity" "current" {}

# Create SageMaker Domain
resource "aws_sagemaker_domain" "domain" {
  domain_name = "sagemaker-domain"
  auth_mode   = "IAM"
  vpc_id      = aws_vpc.sagemaker_vpc.id
  subnet_ids  = [aws_subnet.sagemaker_subnet.id]

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}

# Create SageMaker User Profile
resource "aws_sagemaker_user_profile" "user" {
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = "default-user"

  user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}

# Create VPC
resource "aws_vpc" "sagemaker_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sagemaker-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "sagemaker_subnet" {
  vpc_id     = aws_vpc.sagemaker_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sagemaker-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "sagemaker_igw" {
  vpc_id = aws_vpc.sagemaker_vpc.id

  tags = {
    Name = "sagemaker-igw"
  }
}

# Create Route Table
resource "aws_route_table" "sagemaker_rt" {
  vpc_id = aws_vpc.sagemaker_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sagemaker_igw.id
  }

  tags = {
    Name = "sagemaker-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "sagemaker_rta" {
  subnet_id      = aws_subnet.sagemaker_subnet.id
  route_table_id = aws_route_table.sagemaker_rt.id
}