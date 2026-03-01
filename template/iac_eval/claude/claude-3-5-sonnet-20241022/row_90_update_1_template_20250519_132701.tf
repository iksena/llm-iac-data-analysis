provider "aws" {
  region = "us-west-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Fargate profile"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"] # Replace with actual subnet IDs
}

# Data sources
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# IAM role for Fargate profile
resource "aws_iam_role" "eks_fargate_pod" {
  name = "eks-fargate-pod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the required AWS managed policy
resource "aws_iam_role_policy_attachment" "eks_fargate_pod" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_pod.name
}

# Create Fargate profile
resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "kube-system"
  }

  depends_on = [aws_iam_role_policy_attachment.eks_fargate_pod]
}

# Patch CoreDNS
resource "null_resource" "patch_coredns" {
  triggers = {
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${var.cluster_name} --region us-west-2
      kubectl patch deployment coredns \
        -n kube-system \
        --type json \
        -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"},{"op": "add", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type", "value": "fargate"}]'
    EOT
  }

  depends_on = [aws_eks_fargate_profile.kube_system]
}