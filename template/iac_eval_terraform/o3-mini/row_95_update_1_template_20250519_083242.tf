provider "aws" {
  region = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS Fargate profile"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}

resource "aws_iam_role" "example" {
  name = "example"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = "example"
  fargate_profile_name   = "example-fargate-profile"
  pod_execution_role_arn = aws_iam_role.example.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "example"
  }
}