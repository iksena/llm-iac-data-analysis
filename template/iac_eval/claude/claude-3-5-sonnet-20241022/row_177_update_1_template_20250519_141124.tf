provider "aws" {
  region = "us-west-2"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-image-role"

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
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Image
resource "aws_sagemaker_image" "example" {
  image_name = "my-sagemaker-image"
  role_arn   = aws_iam_role.sagemaker_role.arn

  depends_on = [aws_iam_role_policy_attachment.sagemaker_policy]
}

# Create SageMaker Image Version
resource "aws_sagemaker_image_version" "example" {
  image_name = aws_sagemaker_image.example.image_name
  base_image = "763104351884.dkr.ecr.us-west-2.amazonaws.com/pytorch-training:1.8.1-gpu-py36-cu111-ubuntu18.04"

  depends_on = [aws_sagemaker_image.example]
}

# Output the Image ARN
output "sagemaker_image_arn" {
  value = aws_sagemaker_image.example.arn
}

# Output the Image Version ARN
output "sagemaker_image_version_arn" {
  value = aws_sagemaker_image_version.example.arn
}