Description:
This Terraform program provisions an AWS EKS cluster called "example". It defines an IAM role for the cluster with the necessary assume role policy and attaches the required AWS managed policies (AmazonEKSClusterPolicy and AmazonEKSServicePolicy) via policy attachments. The EKS cluster resource uses the provided VPC subnet IDs (defined as a variable with default values) to configure its networking. The EKS resource has an explicit dependency on the IAM role policy attachments to ensure proper order during creation and deletion. Finally, two outputs expose the cluster's endpoint and the certificate authority data necessary for kubeconfig generation.

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
  region = "us-west-2"
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs for the EKS cluster."
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-fedcba9876543210"]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "example-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.vpc_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster."
  value       = aws_eks_cluster.example.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster."
  value       = aws_eks_cluster.example.certificate_authority[0].data
}
</iac_template>