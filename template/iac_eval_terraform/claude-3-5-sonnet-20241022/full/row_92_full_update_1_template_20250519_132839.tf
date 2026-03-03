I'll help you create a Terraform configuration that associates an access policy with an AWS EKS cluster. This configuration will:

1. Create an EKS cluster access policy association named "example"
2. Link it to a specified EKS cluster
3. Set up access scope limited to a specific namespace
4. Include necessary policy and principal ARNs
5. Configure the AWS provider

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-west-2 region
2. Defines necessary variables with default values
3. Creates an EKS cluster with required networking components (VPC and subnets)
4. Creates necessary IAM roles and policies for the EKS cluster
5. Creates the access policy association with the specified namespace scope

The configuration includes all necessary components to make it fully deployable. The access policy association is created with:
- A link to the EKS cluster
- A policy ARN (customizable through variables)
- A principal ARN (customizable through variables)
- Access scope limited to the "default" namespace

To use this configuration, you can either:
1. Use it as-is with the default values
2. Override the variables by creating a terraform.tfvars file
3. Pass variables during terraform apply using -var flags

Make sure to replace the default ARNs in the variables with your actual ARNs before deploying.