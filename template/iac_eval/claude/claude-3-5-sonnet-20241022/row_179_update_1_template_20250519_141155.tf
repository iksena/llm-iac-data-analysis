provider "aws" {
  region = "us-west-2"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-notebook-role"

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

# Attach AWSServiceRoleForAmazonSageMaker policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_policy" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSageMakerFullAccess"
}

# Create SageMaker Notebook Instance
resource "aws_sagemaker_notebook_instance" "notebook" {
  name                    = "sagemaker-notebook"
  role_arn               = aws_iam_role.sagemaker_role.arn
  instance_type          = "ml.t2.medium"
  volume_size            = 5
  
  tags = {
    Name        = "sagemaker-notebook"
    Environment = "development"
  }
}