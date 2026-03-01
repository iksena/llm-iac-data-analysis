I'll help you create a Terraform configuration for an AWS EKS cluster with the necessary IAM roles and policies. Here's what the configuration will do:

1. Create an IAM role named "demo" for EKS service
2. Attach the required assume role policy
3. Attach AmazonEKSClusterPolicy to the role
4. Create an EKS cluster named "demo" in us-east-1 region
5. Configure VPC settings with specified subnets
6. Handle dependencies properly

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates an EKS cluster with the necessary IAM roles and policies. Note that you'll need to:

1. Replace the subnet IDs in the `subnet_ids` variable with your actual subnet IDs
2. Ensure you have appropriate AWS credentials configured
3. Make sure the subnets exist in the specified VPC and are properly configured for EKS (with appropriate routing and security groups)

The configuration includes:
- AWS provider configuration for us-east-1 region
- IAM role creation with appropriate assume role policy
- AmazonEKSClusterPolicy attachment
- EKS cluster creation with VPC configuration
- Proper dependency handling using depends_on
- Useful outputs for cluster endpoint and certificate authority data

The configuration follows AWS best practices and includes all necessary components for a functional EKS cluster deployment.