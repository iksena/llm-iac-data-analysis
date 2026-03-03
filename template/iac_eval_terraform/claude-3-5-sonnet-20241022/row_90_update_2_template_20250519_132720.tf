provider "aws" {
  region = "us-west-2"
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
  default     = ["subnet-12345678", "subnet-87654321"]
}

# Data sources for existing EKS cluster
data "aws_eks_cluster" "existing" {
  name = var.cluster_name
}

# IAM role for Fargate profile
resource "aws_iam_role" "fargate_pod_execution_role" {
  name = "eks-fargate-pod-execution-role"

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

  tags = {
    Name = "eks-fargate-pod-execution-role"
  }
}

# Attach the AWS managed policy for Fargate pod execution
resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role.name
}

# Create Fargate Profile
resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "kube-system"
  }

  tags = {
    Environment = "production"
  }

  depends_on = [aws_iam_role_policy_attachment.fargate_pod_execution_role]
}

# Null resource for CoreDNS patch
resource "null_resource" "patch_coredns" {
  triggers = {
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
      aws eks get-token --cluster-name ${var.cluster_name} --region us-west-2 > /dev/null 2>&1
      kubectl patch deployment coredns \
        -n kube-system \
        --type=json \
        -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"},{"op": "add", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type", "value": "fargate"}]'
    EOF
  }

  depends_on = [aws_eks_fargate_profile.kube_system]
}