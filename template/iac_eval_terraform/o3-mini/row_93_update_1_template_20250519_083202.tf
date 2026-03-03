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