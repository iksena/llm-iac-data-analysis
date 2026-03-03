provider "aws" {
  region = "us-east-1"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-model-role"

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

# Attach AWSAmazonSageMakerFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_policy" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Model
resource "aws_sagemaker_model" "kmeans_model" {
  name               = "kmeans-model"
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    image = "382416733822.dkr.ecr.us-east-1.amazonaws.com/kmeans:1"
  }

  tags = {
    Name = "kmeans-model"
    Environment = "development"
  }
}