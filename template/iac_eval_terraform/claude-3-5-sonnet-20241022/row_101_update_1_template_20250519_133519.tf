provider "aws" {
  region = "us-east-1"
}

# Variables for VPC subnets
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-12345678", "subnet-87654321"] # Replace with your actual subnet IDs
}

# IAM Role for EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "eks-cluster-demo"
  }
}

# Attach AmazonEKSClusterPolicy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create EKS Cluster
resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Output the endpoint of the EKS cluster
output "endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

# Output the kubeconfig certificate authority data
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}