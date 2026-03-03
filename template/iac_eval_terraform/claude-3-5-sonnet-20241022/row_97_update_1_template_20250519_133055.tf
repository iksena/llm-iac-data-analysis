provider "aws" {
  region = "us-west-2"
}

# Data source to get existing EKS cluster
data "aws_eks_cluster" "example" {
  name = "example"
}

# Get the OIDC provider URL without the protocol
locals {
  oidc_provider = replace(data.aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")
}

# Create the IAM OIDC provider
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280" # This is a common thumbprint for EKS OIDC providers
  ]
  url = data.aws_eks_cluster.example.identity[0].oidc[0].issuer

  tags = {
    Name = "eks-example-oidc-provider"
  }
}

# Create an IAM role that can be used with the OIDC provider
resource "aws_iam_role" "oidc_role" {
  name = "eks-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:sub": "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })

  tags = {
    Name = "eks-oidc-role"
  }
}

# Output the OIDC provider ARN
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
  description = "The ARN of the OIDC Provider"
}

# Output the OIDC provider URL
output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
  description = "The URL of the OIDC Provider"
}