provider "aws" {
  region = "us-west-2"
}

# Create IAM Role for EKS Fargate Profile
resource "aws_iam_role" "eks_fargate_profile" {
  name = "eks-fargate-profile-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-fargate-profile-example"
    Purpose = "EKS Fargate Profile"
  }
}

# Attach the AWS managed policy for EKS Fargate pod execution
resource "aws_iam_role_policy_attachment" "eks_fargate_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_profile.name
}

# Output the Role ARN
output "fargate_profile_role_arn" {
  description = "ARN of the EKS Fargate Profile IAM Role"
  value       = aws_iam_role.eks_fargate_profile.arn
}