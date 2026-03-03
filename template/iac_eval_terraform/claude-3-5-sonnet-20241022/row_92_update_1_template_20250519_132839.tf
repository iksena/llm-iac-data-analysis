provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "policy_arn" {
  description = "ARN of the policy to associate"
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AWSEKSClusterRole"
}

variable "principal_arn" {
  description = "ARN of the principal (user/role)"
  type        = string
  default     = "arn:aws:iam::123456789012:role/EKSClusterAccessRole"
}

# Create the EKS Cluster (if it doesn't exist)
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [aws_subnet.example1.id, aws_subnet.example2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Create VPC for EKS
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "example1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "eks-subnet-1"
  }
}

resource "aws_subnet" "example2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "eks-subnet-2"
  }
}

# Create IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

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
}

# Attach EKS Cluster Policy to Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Create Access Policy Association
resource "aws_eks_access_policy_association" "example" {
  cluster_name = aws_eks_cluster.example.name
  policy_arn   = var.policy_arn
  principal_arn = var.principal_arn

  access_scope {
    namespaces = ["default"]
    type       = "namespace"
  }
}