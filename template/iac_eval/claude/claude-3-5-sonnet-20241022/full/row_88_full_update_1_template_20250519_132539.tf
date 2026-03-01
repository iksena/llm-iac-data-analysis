I'll help you create a Terraform configuration for setting up an EKS cluster with the necessary IAM roles and networking components. Here's a description of what the configuration will do:

1. Create an IAM role named 'eks-cluster-1' for EKS service
2. Attach the AmazonEKSClusterPolicy to the role
3. Create an EKS cluster with configurable name and version
4. Set up VPC networking with public and private subnets
5. Configure the AWS provider for a specific region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}

# VPC Configuration
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "eks-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "eks-public-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "eks-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "eks-private-2"
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-1"

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

# Attach AmazonEKSClusterPolicy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

# Output the cluster name
output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two public and two private subnets across two availability zones
2. An IAM role named 'eks-cluster-1' with the required assume role policy
3. Attaches the AmazonEKSClusterPolicy to the IAM role
4. Creates an EKS cluster with the specified name and version
5. Configures the cluster to use the created VPC and subnets
6. Provides outputs for the cluster endpoint and name

The configuration includes all necessary components and can be deployed as-is. The default values for the variables can be overridden by providing different values in a tfvars file or through command-line arguments.