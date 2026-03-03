provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster" "example" {
  name = "example"
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = data.aws_eks_cluster.example.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  ]

  tags = {
    Name = "eks-example-oidc"
  }
}

resource "aws_iam_role" "oidc_role" {
  name = "eks-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-node"
        }
      }
    }]
  })
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
  description = "The ARN of the OIDC Provider"
}

output "oidc_provider_url" {
  value       = aws_iam_openid_connect_provider.eks_oidc.url
  description = "The URL of the OIDC Provider"
}