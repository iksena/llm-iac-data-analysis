```hcl
provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "example" {
  name = "my-ecr-repo"
}

data "aws_ecr_image" "stable" {
  repository_name = data.aws_ecr_repository.example.name
  image_tag       = "stable"
}

locals {
  image_tag     = data.aws_ecr_image.stable.image_tag
  aws_tags      = {
    Environment = "dev"
    Project     = "example-project"
  }
  workspace_name = terraform.workspace
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.21"
  subnets         = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  vpc_id          = "vpc-0a1b2c3d4e5f6g7h8"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"
      key_name      = "my-key"
    }
  }

  tags = local.aws_tags
}

data "aws_eks_cluster" "my_cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "my_cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.my_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.my_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.my_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.my_cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.my_cluster.certificate_authority[0].data)
  }
}
```