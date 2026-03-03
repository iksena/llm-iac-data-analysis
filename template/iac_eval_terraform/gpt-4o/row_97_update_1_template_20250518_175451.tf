provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_eks_identity_provider_config" "example_oidc" {
  cluster_name = aws_eks_cluster.example.name

  oidc {
    identity_provider_config_name = "example-oidc"
    issuer_url                   = "https://example.com/oidc"
    client_id                    = "example-client-id"
  }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.example.name
}