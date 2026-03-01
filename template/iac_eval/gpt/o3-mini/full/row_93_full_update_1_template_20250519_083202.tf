Description:
This Terraform configuration defines an AWS provider, a variable for the EKS cluster name, and an AWS EKS addon resource. The resource uses the name "example" and attaches an addon named "vpc-cni" to the provided EKS cluster name. The configuration includes default values so that it is deployable out of the box.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the AWS EKS cluster"
  type        = string
  default     = "example-eks-cluster"
}

resource "aws_eks_addon" "example" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
}
</iac_template>