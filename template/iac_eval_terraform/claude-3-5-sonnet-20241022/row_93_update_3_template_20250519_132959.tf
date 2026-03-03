provider "aws" {
  region = "us-west-2"
}

# Variable for cluster name
variable "cluster_name" {
  type    = string
  default = "example-cluster"
}

# Create EKS Addon
resource "aws_eks_addon" "example" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
}