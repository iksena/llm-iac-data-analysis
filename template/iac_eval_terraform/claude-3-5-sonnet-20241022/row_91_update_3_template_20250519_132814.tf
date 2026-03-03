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

# EKS Access Entry
resource "aws_eks_access_entry" "example" {
  cluster_name = var.cluster_name
  principal_arn = var.principal_arn
  kubernetes_groups = ["system:masters"]
}