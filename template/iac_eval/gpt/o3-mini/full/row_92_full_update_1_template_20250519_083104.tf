Below is the design description and the complete deployable Terraform template. In this solution we create a minimal EKS cluster (with a basic VPC/subnet), an IAM role resource called “example” (with the attached policy from var.policy_arn) and then we “associate” that role with a Kubernetes service account in a dedicated namespace (var.namespace). By using IRSA (IAM Roles for Service Accounts) the IAM role becomes linked to the cluster – the “access policy” named “example” is attached to the IAM role while the service account (in the dedicated namespace) “inherits” that access. In addition a Kubernetes Role and RoleBinding are created in that namespace so that any pods using the service account get a pre‐defined, namespace–limited set of permissions. (The mapping of the EKS cluster name is also recorded in the names and tags of the resources.) 

Below is the complete Terraform HCL configuration enclosed in <iac_template> tags:

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
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get the current account (for tagging purposes)
data "aws_caller_identity" "current" {}

#############################
# VPC and subnet for EKS
#############################
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "example-subnet"
  }
}

#############################
# IAM Role for the EKS Cluster
#############################
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  tags = {
    eks_cluster = var.cluster_name
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#############################
# EKS Cluster
#############################
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.example.id]
  }

  # For simplicity we let the cluster create its own OIDC issuer.
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = {
    Name = var.cluster_name
  }
}

# To let the Kubernetes provider connect, we need the cluster auth info
data "aws_eks_cluster_auth" "example" {
  name = aws_eks_cluster.example.name
}

#############################
# Kubernetes Provider
#############################
provider "kubernetes" {
  host                   = aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}

#############################
# Create the OIDC Provider for IRSA
#############################
# The issuer URL from the EKS cluster identity is used.
resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  # The thumbprint for EKS OIDC issuer is commonly this value.
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0eaaaab4b"]
}

#############################
# IAM Role for the Access Policy "example"
# (This role’s name is "example" and it will have the attached policy from var.policy_arn.)
#############################
data "aws_iam_policy_document" "example_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    # Condition to restrict usage to the specified namespace and a service account name "example-sa"
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:example-sa"]
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "example" 
  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
  tags = {
    eks_cluster = var.cluster_name
  }
}

# Attach the provided access policy to the "example" role.
resource "aws_iam_role_policy_attachment" "example_policy_attachment" {
  role       = aws_iam_role.example.name
  policy_arn = var.policy_arn
}

#############################
# Kubernetes Namespace for limited access
#############################
resource "kubernetes_namespace" "example_ns" {
  metadata {
    name = var.namespace
  }
}

#############################
# Service Account associated with the IAM Role "example"
# (This is the IRSA binding; pods using this service account will get the role.)
#############################
resource "kubernetes_service_account" "example_sa" {
  metadata {
    name      = "example-sa"
    namespace = kubernetes_namespace.example_ns.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.example.arn
    }
  }
}

#############################
# Kubernetes Role to explicitly limit access to the specified namespace
#############################
resource "kubernetes_role" "example_role" {
  metadata {
    name      = "example-role"
    namespace = kubernetes_namespace.example_ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}

#############################
# Bind the IAM-associated Service Account to the Role
#############################
resource "kubernetes_role_binding" "example_rolebinding" {
  metadata {
    name      = "example-rolebinding"
    namespace = kubernetes_namespace.example_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.example_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.example_sa.metadata[0].name
    namespace = kubernetes_service_account.example_sa.metadata[0].namespace
  }
}

#############################
# Variables with Defaults
#############################
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example-eks"
}

variable "policy_arn" {
  description = "The ARN of the access policy to attach to the example role"
  type        = string
  # Example default policy. You can change this ARN as needed.
  default     = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

variable "namespace" {
  description = "Kubernetes namespace for limited access"
  type        = string
  default     = "example-namespace"
}
</iac_template>

In this template the IAM role named “example” is tied to the EKS cluster via an OIDC provider and then bound to a service account in the chosen namespace. That service account is granted limited (“read‐only” on pods, services, and configmaps) access via a Kubernetes Role and RoleBinding. This meets the business need to associate a named “example” access policy (via its attached IAM policy) with a specific cluster (by name and tagging) and to limit access to a specified namespace.