I'll help you create a Terraform configuration for setting up an AWS IAM role and an EKS cluster with the specified requirements.

Description:
This Terraform configuration will:
1. Create an IAM role named "demo_eks" with a trust relationship for EKS service
2. Attach required AWS managed policies (AmazonEKSClusterPolicy and AmazonEKSVPCResourceController) to the role
3. Create an EKS cluster named "demo_eks" using the created IAM role
4. Set up necessary VPC configurations for the EKS cluster
5. Handle dependencies properly to ensure smooth deployment

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "demo_eks"
}

# VPC Configuration
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Create IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}_role"

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

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create internet gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Create route table
resource "aws_route_table" "eks_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.eks_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.eks_rt.id
}

# Create EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

# Output the cluster certificate authority data
output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
</iac_template>

This configuration creates:
1. A VPC with two public subnets in different availability zones
2. An IAM role with necessary permissions for EKS
3. Required policy attachments
4. An EKS cluster with proper networking setup
5. Internet Gateway and route tables for network connectivity
6. Appropriate outputs for cluster information

The configuration handles dependencies correctly and ensures that the IAM role has the required permissions before creating the EKS cluster. The VPC is properly configured with public subnets, internet gateway, and route tables to allow the EKS cluster to function correctly.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Make sure you have appropriate AWS credentials configured before applying this configuration.