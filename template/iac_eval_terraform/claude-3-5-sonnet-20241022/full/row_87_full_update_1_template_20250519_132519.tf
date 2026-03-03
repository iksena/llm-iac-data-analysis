I'll help you create a Terraform configuration for an AWS EKS cluster with the specified requirements. This configuration will:

1. Define a variable for the cluster name
2. Create necessary IAM roles and policies for EKS
3. Create an EKS cluster with VPC networking
4. Configure kubectl using local-exec provisioners
5. Include proper IAM role permissions and policy attachments

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variable definition
variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

# VPC Data Source (assuming VPC exists)
data "aws_vpc" "existing" {
  default = true
}

data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

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

# Attach required policies to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = data.aws_subnets.existing.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
  ]

  # Configure kubectl after cluster creation
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region us-west-2"
  }

  # Remove kubectl configuration when destroying cluster
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl config delete-context ${self.name}"
  }
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}
</iac_template>

This Terraform configuration creates an EKS cluster with the following components:

1. A variable `cluster_name` with a default value of "my-eks-cluster"
2. Data sources to fetch existing VPC and subnet information
3. An IAM role for the EKS cluster with necessary trust relationships
4. Policy attachments for EKS cluster and service policies
5. The EKS cluster itself with VPC networking configuration
6. Local-exec provisioners to manage kubectl configuration
7. Output values for cluster endpoint and name

The configuration uses the AWS provider and assumes you have appropriate AWS credentials configured. It uses the default VPC and its subnets for simplicity, but you can modify the networking configuration as needed.

The local-exec provisioners handle kubectl configuration management:
- During creation: configures kubectl to work with the new cluster
- During destruction: removes the kubectl context for the cluster

Make sure you have the AWS CLI and kubectl installed on the machine where you run this Terraform configuration.