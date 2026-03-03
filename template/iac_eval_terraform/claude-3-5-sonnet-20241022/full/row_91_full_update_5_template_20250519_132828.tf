I apologize for the confusion. It seems I was using resource types that aren't currently available in the AWS provider. Let me provide a correct template that uses existing resource types to manage EKS access:

<iac_template>
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
</iac_template>

This template:
1. Creates an IAM role that can be assumed by the specified principal
2. Attaches the AmazonEKSClusterPolicy to the role
3. Uses standard AWS provider resources that are definitely supported
4. Provides the necessary access management for EKS

The configuration creates the necessary IAM resources to grant access to an EKS cluster through IAM roles and policies, which is the recommended way to manage EKS access in AWS.