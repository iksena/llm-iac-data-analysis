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

# EKS Access Entry Resource
resource "aws_eks_access_entry" "example" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  access_type       = "STANDARD"
  kubernetes_groups = ["system:masters", "eks-console-dashboard-full-access-group"]

  tags = {
    Name        = "example-access-entry"
    Environment = "production"
  }
}

# Output
output "access_entry_id" {
  description = "The ID of the EKS access entry"
  value       = aws_eks_access_entry.example.id
}