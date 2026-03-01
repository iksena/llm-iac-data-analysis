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

# EKS Access Policy Association
resource "aws_eks_access_policy_association" "example" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}