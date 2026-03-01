provider "aws" {
  region = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "service_account" {
  description = "Kubernetes service account name"
  type        = string
  default     = "example-sa"
}

# Get existing EKS cluster data
data "aws_eks_cluster" "example" {
  name = var.cluster_name
}

# Create OIDC Provider for EKS
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]  # Example thumbprint - replace with actual
  url = data.aws_eks_cluster.example.identity[0].oidc[0].issuer
}

# Create IAM role
resource "aws_iam_role" "example" {
  name = "eks-pod-identity-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub": "system:serviceaccount:${var.namespace}:${var.service_account}"
        }
      }
    }]
  })
}

# Attach S3 read-only policy to the role
resource "aws_iam_role_policy_attachment" "s3_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.example.name
}

# Create EKS pod identity association
resource "aws_eks_pod_identity_association" "example" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account
  role_arn       = aws_iam_role.example.arn
}