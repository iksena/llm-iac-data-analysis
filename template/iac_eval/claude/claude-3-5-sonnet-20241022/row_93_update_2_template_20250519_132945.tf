provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example-cluster"
}

# Data source for existing EKS cluster
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# EKS Addon for VPC-CNI
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
  
  # Optional: Specify version if needed
  # addon_version = "v1.12.0-eksbuild.1"
  
  # Handle conflict resolution
  resolve_conflicts = "OVERWRITE"
}

# Output the addon version
output "vpc_cni_addon_version" {
  description = "The version of the VPC-CNI addon"
  value       = aws_eks_addon.vpc_cni.addon_version
}