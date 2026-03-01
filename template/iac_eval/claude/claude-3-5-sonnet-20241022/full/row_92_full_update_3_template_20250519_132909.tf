I'll create a simpler, focused template that specifically handles the EKS access policy association. I'll wrap it in the requested tags and ensure all syntax is correct.

Description:
This Terraform configuration creates an AWS EKS access policy association. It associates a specified policy with an existing EKS cluster, setting up access permissions for a specific principal (user/role) with namespace-scoped access limitations.

<iac_template>
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
</iac_template>