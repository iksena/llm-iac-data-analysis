Description:
This Terraform configuration provisions an AWS IAM role named "example" for use with an Amazon EKS cluster. The IAM role’s trust (assume role) policy file is configured to allow Amazon EKS services (eks.amazonaws.com) to assume the role, and it attaches the managed policy AmazonEKSClusterPolicy. The configuration also creates a VPC and a subnet to be used for the EKS cluster. The AWS EKS cluster named "example" is defined with its VPC configuration referencing the subnet we created and specifies that its endpoint private access is disabled while the public access is enabled. Proper dependency is established to ensure that the IAM role policy attachment is completed prior to EKS cluster creation.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create a VPC for the EKS cluster
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Create a subnet in the above VPC
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "example-subnet"
  }
}

# Create an IAM role for EKS Cluster with a trust policy for eks.amazonaws.com
resource "aws_iam_role" "example" {
  name = "example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "example"
  }
}

# Attach the AmazonEKSClusterPolicy managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create an EKS Cluster
resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids              = [aws_subnet.example.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  # Ensure the IAM policy attachment completes before the cluster is created
  depends_on = [
    aws_iam_role_policy_attachment.example
  ]

  tags = {
    Name = "example"
  }
}
</iac_template>