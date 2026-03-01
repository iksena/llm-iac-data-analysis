Description:
This Terraform configuration creates an IAM role named "eks-cluster-1" that can be assumed by the service "eks.amazonaws.com". The role has the managed policy "AmazonEKSClusterPolicy" attached. In addition, the configuration deploys an AWS EKS cluster with a name derived from a provided variable and a configurable Kubernetes version. The cluster is associated with the IAM role, and its VPC configuration is set up using a list of subnet IDs (covering both private and public subnets) to ensure proper networking in the specified AWS region.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name for the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.21"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster VPC."
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789a"]
}

resource "aws_iam_role" "eks_cluster" {
  name               = "eks-cluster-1"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
</iac_template>