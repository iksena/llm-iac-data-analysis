provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-eks-cluster"
  version  = "1.21"

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = ["subnet-0123456789abcdef0"] # Replace with your actual subnet ID
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  default     = "vpc-0123456789abcdef0" # Replace with your actual VPC ID
}