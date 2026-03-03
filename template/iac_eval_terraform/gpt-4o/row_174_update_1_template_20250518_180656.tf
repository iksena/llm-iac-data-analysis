provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name = "SageMakerPolicy"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ecr:*",
          "cloudwatch:*",
          "logs:*",
          "cloudtrail:*",
          "sagemaker:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_domain" "sagemaker_domain" {
  domain_name = "example-sagemaker-domain"
  auth_mode   = "IAM"

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }

  vpc_id = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.main.id
  ]
}

resource "aws_sagemaker_space" "sagemaker_space" {
  domain_id = aws_sagemaker_domain.sagemaker_domain.id
  space_name = "example-space"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}