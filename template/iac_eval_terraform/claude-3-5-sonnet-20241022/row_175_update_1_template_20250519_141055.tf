provider "aws" {
  region = "us-west-2"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-role"

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

# Create VPC Endpoint for SageMaker API
resource "aws_vpc_endpoint" "sagemaker_api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.us-west-2.sagemaker.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.main.id]

  security_group_ids = [
    aws_security_group.sagemaker_endpoint_sg.id,
  ]
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sagemaker-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sagemaker-subnet"
  }
}

# Create Security Group
resource "aws_security_group" "sagemaker_endpoint_sg" {
  name        = "sagemaker-endpoint-sg"
  description = "Security group for SageMaker endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create SageMaker Domain
resource "aws_sagemaker_domain" "domain" {
  domain_name = "sagemaker-domain"
  auth_mode   = "IAM"
  vpc_id      = aws_vpc.main.id
  subnet_ids  = [aws_subnet.main.id]

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }
}

# Create SageMaker User Profile
resource "aws_sagemaker_user_profile" "user" {
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = "default-user"

  user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }
}

# Create SageMaker App
resource "aws_sagemaker_app" "jupyter" {
  domain_id         = aws_sagemaker_domain.domain.id
  user_profile_name = aws_sagemaker_user_profile.user.user_profile_name
  app_name          = "default"
  app_type         = "JupyterServer"
}