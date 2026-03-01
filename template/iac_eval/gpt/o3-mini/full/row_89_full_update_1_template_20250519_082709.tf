Below is an explanation of the Terraform program followed by the complete HCL configuration. This configuration sets up the AWS provider in the us-west-2 region, obtains the current caller identity, and (optionally) retrieves the latest stable image from a specified ECR repository. It also defines local variables (an image tag, AWS tags, and a workspace name), creates a minimal VPC with subnets to support an EKS cluster, instantiates an EKS module (from terraform-aws-modules/eks/aws) with required settings (including IAM policies, instance types, and node count), retrieves the EKS cluster information and authentication token, then configures both the Kubernetes and Helm providers to communicate with the newly created cluster.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Retrieve the current caller identity
data "aws_caller_identity" "current" {}

# Optionally retrieve the latest stable ECR image (using the 'stable' tag)
data "aws_ecr_repository" "repo" {
  name = "my-ecr-repo"  # Change this to your actual repository name if needed
}

data "aws_ecr_image" "stable_image" {
  repository_name = data.aws_ecr_repository.repo.name
  image_tag       = local.image_tag
}

# Define local variables including image tag, AWS tags, and workspace name
locals {
  image_tag      = "stable"
  aws_tags       = {
    Environment = "Production"
    Terraform   = "true"
  }
  workspace_name = "dev-workspace"
}

# Create a minimal VPC for the EKS cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.aws_tags, { Name = "${local.workspace_name}-vpc" })
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = merge(local.aws_tags, { Name = "${local.workspace_name}-igw" })
}

# Create two subnets in different availability zones
resource "aws_subnet" "eks_subnet" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone = element(["us-west-2a", "us-west-2b"], count.index)
  tags              = merge(local.aws_tags, { Name = "${local.workspace_name}-subnet-${count.index}" })
}

# Instantiate the EKS module with cluster, IAM policies, instance types, and node count
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 18.0"

  cluster_name    = local.workspace_name
  cluster_version = "1.24"
  subnets         = aws_subnet.eks_subnet[*].id
  vpc_id          = aws_vpc.eks_vpc.id

  node_groups = {
    eks_nodes = {
      desired_capacity             = 2
      max_capacity                 = 3
      min_capacity                 = 1
      instance_type                = "t3.medium"
      additional_tags              = local.aws_tags
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      ]
    }
  }

  tags = local.aws_tags
}

# Retrieve the EKS cluster authentication token
data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

# Configure the Kubernetes provider using the created EKS cluster’s endpoint and certificate
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

# Configure the Helm provider to use the same Kubernetes cluster details
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
</iac_template>