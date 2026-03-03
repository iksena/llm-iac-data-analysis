provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
  default     = "existing-eks-cluster"
}

variable "policy_arn" {
  description = "ARN of the policy to associate"
  type        = string
  default     = "arn:aws:eks::111122223333:cluster-access-policy/example-policy"
}

variable "principal_arn" {
  description = "ARN of the principal (user/role)"
  type        = string
  default     = "arn:aws:iam::111122223333:role/example-role"
}

# Create Access Policy Association
resource "aws_eks_access_policy_association" "example" {
  cluster_name  = var.cluster_name
  policy_arn    = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    type        = "namespace"
    namespaces  = ["default"]
  }
}