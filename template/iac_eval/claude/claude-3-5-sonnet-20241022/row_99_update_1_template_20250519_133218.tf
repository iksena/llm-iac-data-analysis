provider "aws" {
  region = "us-west-2"
}

# Variables
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

# IAM Policy Document for assuming role
data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
    }
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get existing EKS cluster data
data "aws_eks_cluster" "example" {
  name = var.cluster_name
}

# Create IAM role for EKS pods
resource "aws_iam_role" "example" {
  name               = "eks-pod-identity-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
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