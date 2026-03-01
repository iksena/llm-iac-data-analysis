I'll help you create a Terraform configuration for an EKS cluster with the required IAM role and networking components. Here's what the configuration will include:

1. AWS Provider configuration
2. VPC with public subnet
3. IAM role for EKS cluster with assume role policy
4. AmazonEKSClusterPolicy attachment
5. EKS cluster configuration with the specified settings

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
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

# Public Subnet
resource "aws_subnet" "eks_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

# Route Table
resource "aws_route_table" "eks_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "eks-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "eks_rta" {
  subnet_id      = aws_subnet.eks_subnet.id
  route_table_id = aws_route_table.eks_rt.id
}

# IAM Role for EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "example"

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
resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = [aws_subnet.eks_subnet.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
</iac_template>

This Terraform configuration creates:
1. A VPC with a CIDR block of 10.0.0.0/16
2. A public subnet in the VPC
3. An Internet Gateway and associated route table for internet access
4. An IAM role named "example" with the required assume role policy for EKS
5. Attaches the AmazonEKSClusterPolicy to the IAM role
6. Creates an EKS cluster named "example" with the specified endpoint access settings

The configuration includes proper dependency handling using the depends_on block in the EKS cluster resource to ensure the IAM role policy is attached before creating the cluster. The VPC and networking components are properly configured to allow the EKS cluster to function correctly.

All resources are fully specified and include necessary tags where appropriate. The configuration uses the us-west-2 (Oregon) region but can be modified as needed.