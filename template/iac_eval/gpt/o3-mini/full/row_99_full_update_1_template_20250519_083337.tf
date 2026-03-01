Below is a complete Terraform configuration written in HCL that creates an IAM policy document for pod identity (the trust relationship for EKS pods), an IAM role named “example” which can be assumed via web identity (the role trust is restricted to a specific service account on an EKS cluster called “example”), attaches the AWS managed AmazonS3ReadOnlyAccess policy to that role, and then creates a Kubernetes service account (with IRSA annotations) in an EKS cluster named “example” in order to complete the pod identity association.

In this example the EKS cluster is referenced using the data source (so it must already exist) and its OIDC issuer is used to create an IAM OIDC Provider. The Kubernetes provider is also configured using the EKS cluster “example” so that the annotated service account is created on the actual cluster. Default values are provided for the variables.

Below is the complete HCL configuration:

<iac_template>
###############################################################################
# Providers and Variables
###############################################################################
provider "aws" {
  region = var.aws_region
}

# The Kubernetes provider uses the EKS cluster endpoint and authentication info.
data "aws_eks_cluster" "example" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "example" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
  load_config_file       = false
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster (must pre-exist)"
  type        = string
  default     = "example"
}

variable "eks_namespace" {
  description = "The Kubernetes namespace to deploy the service account"
  type        = string
  default     = "default"
}

variable "eks_service_account" {
  description = "The name of the Kubernetes service account to link to IAM Role"
  type        = string
  default     = "example"
}

###############################################################################
# IAM OIDC Provider for EKS Cluster
###############################################################################
# Create an IAM OIDC provider resource for the EKS cluster.
# This is needed for IRSA to allow pod identities.
resource "aws_iam_openid_connect_provider" "example" {
  url             = data.aws_eks_cluster.example.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0cedf5a2b"]
}

###############################################################################
# IAM Policy Document for EKS Pod Identity (Trust Policy)
###############################################################################
# Build the IAM policy document used as the assume role policy.
# It restricts access to only the specific service account in the target namespace.
data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.example.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    # Remove "https://" from the issuer URL for use in the condition key.
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.eks_namespace}:${var.eks_service_account}"]
    }
  }
}

###############################################################################
# Create the IAM Role for Pod Identity and Attach S3 Read-Only Policy
###############################################################################
resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.example.json
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

###############################################################################
# Kubernetes Service Account with IRSA Annotation for Pod Identity
###############################################################################
resource "kubernetes_service_account" "example" {
  metadata {
    name      = var.eks_service_account
    namespace = var.eks_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.example.arn
    }
  }
}
</iac_template>

This configuration meets the business need by:
1. Creating the IAM trust policy (using aws_iam_policy_document "example") for pods.
2. Creating an IAM role named “example” that uses this trust policy.
3. Attaching the AmazonS3ReadOnlyAccess policy to the IAM role.
4. Setting up a Kubernetes service account (with the proper IRSA annotation) in the target EKS cluster—which thus associates the IAM role with pods running under that service account.