provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_fargate_profile" {
  name = "eks-fargate-profile-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_policy_attach" {
  role       = aws_iam_role.eks_fargate_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}