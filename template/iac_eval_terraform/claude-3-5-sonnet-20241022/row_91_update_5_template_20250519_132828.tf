provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "principal_arn" {
  description = "ARN of the principal to grant access"
  type        = string
  default     = "arn:aws:iam::123456789012:role/example-role"
}

# Create an IAM role for EKS access
resource "aws_iam_role" "eks_access" {
  name = "eks-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.principal_arn
        }
      }
    ]
  })
}

# Attach the EKS cluster policy to the role
resource "aws_iam_role_policy_attachment" "eks_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_access.name
}

# Output the role ARN
output "eks_access_role_arn" {
  description = "The ARN of the EKS access role"
  value       = aws_iam_role.eks_access.arn
}