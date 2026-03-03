terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Look up the EKS cluster using its name.
data "aws_eks_cluster" "example" {
  name = var.cluster_name
}

# Get the authentication token for accessing the cluster.
data "aws_eks_cluster_auth" "example" {
  name = var.cluster_name
}

# Configure the Kubernetes provider to connect to our EKS cluster.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

# This resource creates (or updates) the aws-auth ConfigMap which maps a principal ARN to a Kubernetes user.
# Note: Overwriting aws-auth completely might not be desirable in production if there are existing mappings.
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  
  data = {
    # The aws-auth ConfigMap uses a YAML string for mapRoles. Here we encode our role mapping.
    # The mapping grants the principal (having var.principal_arn) access to the EKS cluster,
    # mapping it to the Kubernetes username "example", assigning the specified groups and access type.
    mapRoles = yamlencode([
      {
        rolearn    = var.principal_arn
        username   = "example"
        groups     = var.k8s_groups
        accessType = var.access_type
      }
    ])
  }
}

# Variables with default values.
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example-cluster"
}

variable "principal_arn" {
  description = "ARN of the principal (IAM role) to be granted access"
  type        = string
  default     = "arn:aws:iam::123456789012:role/ExampleRole"
}

variable "k8s_groups" {
  description = "List of Kubernetes groups to assign to the principal"
  type        = list(string)
  default     = ["system:masters"]
}

variable "access_type" {
  description = "Specifies the type of access (should be set to STANDARD)"
  type        = string
  default     = "STANDARD"
}