Below is a description of the Terraform program followed by the complete HCL code inside <iac_template> tags.

Description:
This Terraform configuration sets up an AWS IAM role named demo_eks that is used by an Amazon EKS cluster. The IAM role is configured with an assume role policy allowing EKS to assume the role, and it has the AmazonEKSClusterPolicy and AmazonEKSVPCResourceController managed policies attached. In addition, a basic VPC is created with two subnets residing in different availability zones (us-east-1a and us-east-1b). Finally, an Amazon EKS cluster named demo_eks is defined using the IAM role and the VPC subnet configuration. Proper dependency handling is implemented so that the EKS cluster creation waits for the IAM role and its policy attachments to be available.

<iac_template>
provider "aws" {
  region  = var.aws_region
  version = "~> 4.0"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

###########################
# IAM Role for EKS Cluster
###########################

resource "aws_iam_role" "demo_eks" {
  name = "demo_eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.demo_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.demo_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

###########################
# VPC and Subnets
###########################

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demo_vpc"
  }
}

resource "aws_subnet" "demo_subnet1" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo_subnet1"
  }
}

resource "aws_subnet" "demo_subnet2" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo_subnet2"
  }
}

###########################
# EKS Cluster
###########################

resource "aws_eks_cluster" "demo_eks" {
  name     = "demo_eks"
  role_arn = aws_iam_role.demo_eks.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.demo_subnet1.id,
      aws_subnet.demo_subnet2.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
}

###########################
# Outputs
###########################

output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.demo_eks.id
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.demo_eks.endpoint
}
</iac_template>