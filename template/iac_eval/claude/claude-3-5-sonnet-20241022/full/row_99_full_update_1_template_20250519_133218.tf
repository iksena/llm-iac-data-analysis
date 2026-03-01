I'll help you create a Terraform configuration for AWS EKS with pod identity management. This configuration will:

1. Set up the AWS provider
2. Create an IAM policy document for pod role assumption
3. Create an IAM role for EKS pods
4. Attach AWS managed S3 read-only policy to the role
5. Create an EKS pod identity association

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "service_account" {
  description = "Kubernetes service account name"
  type        = string
  default     = "example-sa"
}

# IAM Policy Document for assuming role
data "aws_iam_policy_document" "example" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
    }
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get existing EKS cluster data
data "aws_eks_cluster" "example" {
  name = var.cluster_name
}

# Create IAM role for EKS pods
resource "aws_iam_role" "example" {
  name               = "eks-pod-identity-role"
  assume_role_policy = data.aws_iam_policy_document.example.json
}

# Attach S3 read-only policy to the role
resource "aws_iam_role_policy_attachment" "s3_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.example.name
}

# Create EKS pod identity association
resource "aws_eks_pod_identity_association" "example" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account
  role_arn       = aws_iam_role.example.arn
}
</iac_template>

This Terraform configuration creates a complete pod identity setup for AWS EKS. Here's what each part does:

1. The AWS provider is configured for the us-west-2 region
2. Variables are defined for cluster name, namespace, and service account with default values
3. An IAM policy document is created that allows role assumption with Web Identity Federation
4. The configuration gets the current AWS account ID and existing EKS cluster data
5. An IAM role is created using the policy document
6. The AWS managed S3 read-only policy is attached to the role
7. An EKS pod identity association is created to link the role with the specified service account

Note: This configuration assumes that:
- An EKS cluster named "example" already exists
- The EKS cluster has OIDC provider configuration enabled
- You have appropriate permissions to create IAM roles and policies
- You want to use the default namespace and service account names (which can be changed via variables)

To use this configuration, you'll need to:
1. Initialize Terraform: `terraform init`
2. Review the planned changes: `terraform plan`
3. Apply the configuration: `terraform apply`