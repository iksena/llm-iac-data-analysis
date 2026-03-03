terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
  default     = "my-existing-cluster"
}

variable "policy_arn" {
  description = "ARN of the policy to associate"
  type        = string
  default     = "arn:aws:eks:us-west-2:111122223333:cluster-access-policy/example-policy"
}

variable "principal_arn" {
  description = "ARN of the principal (user/role)"
  type        = string
  default     = "arn:aws:iam:111122223333:role/example-role"
}

resource "aws_eks_access_entry" "example" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  kubernetes_groups = ["system:masters"]
  
  tags = {
    Name = "example-access-entry"
  }
}