provider "aws" {
  region = "us-west-2"
}

# Create IAM role for Fargate pod execution
resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "example"

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
}

# Attach required policy for Fargate pod execution
resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

# Create Fargate Profile
resource "aws_eks_fargate_profile" "example" {
  cluster_name           = "example"
  fargate_profile_name   = "example-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn

  # Subnet configuration - using private subnets
  subnet_ids = [
    "subnet-xxxxxx1",  # Replace with actual subnet IDs
    "subnet-xxxxxx2"
  ]

  selector {
    namespace = "example"
  }

  # Optional: Add labels selector
  selector {
    namespace = "example"
    labels = {
      Environment = "dev"
    }
  }
}

# Variables with default values
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example"
}

variable "profile_name" {
  description = "Name of the Fargate profile"
  type        = string
  default     = "example-fargate-profile"
}