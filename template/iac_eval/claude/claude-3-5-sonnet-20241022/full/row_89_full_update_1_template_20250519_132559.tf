I'll help you create a Terraform configuration that sets up an EKS cluster with the necessary providers and configurations. This configuration will:
1. Set up AWS provider and fetch caller identity
2. Configure ECR image retrieval
3. Define local variables for resource tagging and configuration
4. Create an EKS cluster using the official AWS EKS module
5. Set up Helm and Kubernetes providers for cluster management

Here's the complete Terraform configuration:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Get caller identity
data "aws_caller_identity" "current" {}

# Get ECR image
data "aws_ecr_image" "service_image" {
  repository_name = "my-app-repo"
  image_tag      = "stable"
}

locals {
  image_tag = "stable"
  tags = {
    Environment = terraform.workspace
    Terraform   = "true"
    Project     = "eks-deployment"
  }
  workspace_name = terraform.workspace
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"

  vpc_id     = "vpc-12345678" # Replace with your VPC ID
  subnet_ids = ["subnet-12345678", "subnet-87654321"] # Replace with your subnet IDs

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = local.tags
}

# Get EKS cluster info
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Output important cluster information
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "caller_identity" {
  description = "Current caller identity"
  value       = data.aws_caller_identity.current.arn
}
</iac_template>

This Terraform configuration creates a complete EKS setup with the following components:

1. Required providers (AWS, Kubernetes, and Helm)
2. AWS provider configuration for us-west-2 region
3. Data sources for caller identity and ECR image
4. Local variables for tagging and configuration
5. EKS module configuration with:
   - Managed node groups
   - Cluster version 1.24
   - T3.medium instance types
   - Auto-scaling configuration
6. Kubernetes and Helm provider configuration using EKS cluster data
7. IAM role and policy for EKS cluster
8. Output values for cluster endpoint, name, and caller identity

Note: You'll need to replace the following placeholder values with your actual values:
- vpc_id: Your VPC ID
- subnet_ids: Your subnet IDs
- my-app-repo: Your ECR repository name

The configuration includes all necessary providers and IAM roles, and ensures that all resources are properly declared and referenced.