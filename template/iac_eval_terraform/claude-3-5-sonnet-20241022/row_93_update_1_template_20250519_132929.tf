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

# Data source to get existing EKS cluster
data "aws_eks_cluster" "existing" {
  name = var.cluster_name
}

# EKS Addon resource
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = data.aws_eks_cluster.existing.name
  addon_name   = "vpc-cni"

  # Configure addon settings
  addon_version            = "latest"
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc_cni.arn

  depends_on = [aws_iam_role_policy_attachment.vpc_cni]
}

# IAM role for VPC CNI
resource "aws_iam_role" "vpc_cni" {
  name = "eks-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.aws_eks_cluster.existing.identity[0].oidc[0].issuer
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.existing.identity[0].oidc[0].issuer, "https://", "")}:sub" : "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# Attach the required policy for VPC CNI
resource "aws_iam_role_policy_attachment" "vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}

# Output the addon version
output "vpc_cni_version" {
  description = "Installed VPC CNI addon version"
  value       = aws_eks_addon.vpc_cni.addon_version
}