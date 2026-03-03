I'll help you create a Terraform configuration to add the vpc-cni addon to an existing AWS EKS cluster. This configuration will:

1. Set up the AWS provider
2. Define variables for the cluster name and region
3. Create an EKS addon resource for vpc-cni
4. Include necessary configurations for the addon

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example-cluster"
}

# Data source to get existing EKS cluster
data "aws_eks_cluster" "existing" {
  name = var.cluster_name
}

# EKS Addon resource
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = data.aws_eks_cluster.existing.name
  addon_name   = "vpc-cni"

  # Configure addon settings
  addon_version            = "latest"
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.vpc_cni.arn

  depends_on = [aws_iam_role_policy_attachment.vpc_cni]
}

# IAM role for VPC CNI
resource "aws_iam_role" "vpc_cni" {
  name = "eks-vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = data.aws_eks_cluster.existing.identity[0].oidc[0].issuer
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.existing.identity[0].oidc[0].issuer, "https://", "")}:sub" : "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# Attach the required policy for VPC CNI
resource "aws_iam_role_policy_attachment" "vpc_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni.name
}

# Output the addon version
output "vpc_cni_version" {
  description = "Installed VPC CNI addon version"
  value       = aws_eks_addon.vpc_cni.addon_version
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider with a default region of us-west-2
2. Defines variables for the AWS region and cluster name
3. Creates a data source to reference the existing EKS cluster
4. Creates an IAM role and attaches the necessary policy for the VPC CNI addon
5. Creates the EKS addon resource for vpc-cni with the following configurations:
   - Uses the latest version of the addon
   - Sets conflict resolution to OVERWRITE
   - Associates the created IAM role
6. Outputs the installed addon version

To use this configuration:
1. Make sure you have AWS credentials configured
2. Update the default values for variables if needed
3. Run `terraform init` followed by `terraform plan` and `terraform apply`

The configuration assumes there's an existing EKS cluster and will add the vpc-cni addon to it. The addon will use the latest available version and will overwrite any existing configuration if there are conflicts.