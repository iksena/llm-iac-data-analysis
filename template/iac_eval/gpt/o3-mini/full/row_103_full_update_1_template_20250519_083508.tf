Below is a description of the Terraform program followed by the complete deployable template.

Description:
• The provider is set to AWS in the us-east-1 region.
• An AWS IAM role named "eks-cluster" is created with a trust policy that allows the EKS service (eks.amazonaws.com) to assume the role.
• The AmazonEKSClusterPolicy managed policy is attached to the IAM role.
• An Amazon VPC (CIDR 10.0.0.0/16) and a subnet (CIDR 10.0.1.0/24) are created.
• An Amazon EKS cluster is created using the IAM role and assigned to the created subnet in the VPC. The cluster is set to a specified Kubernetes version (default "1.21" that can be changed), with endpoint private access disabled and public access enabled.
• The dependency on the IAM role’s policy attachment is explicitly defined for the EKS cluster to ensure proper ordering.

Below is the complete Terraform HCL template:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster"

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

# Attach the AmazonEKSClusterPolicy managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create a VPC for the EKS cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

# Create a subnet within the above VPC
resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-subnet"
  }
}

# Create an EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.21"

  vpc_config {
    subnet_ids              = [aws_subnet.eks_subnet.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  # Ensure the IAM role policy attachment is complete before creating the cluster.
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}
</iac_template>