I'll help you create a Terraform configuration for an AWS EKS access entry. This configuration will:

1. Set up the AWS provider
2. Create an EKS access entry resource that grants access to a specified EKS cluster
3. Include necessary variables with default values
4. Configure standard access with specific Kubernetes groups

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
  default     = "my-eks-cluster"
}

variable "principal_arn" {
  description = "ARN of the principal to grant access"
  type        = string
  default     = "arn:aws:iam::123456789012:role/example-role"
}

# EKS Access Entry Resource
resource "aws_eks_access_entry" "example" {
  cluster_name      = var.cluster_name
  principal_arn     = var.principal_arn
  type             = "STANDARD"
  kubernetes_groups = ["system:masters", "eks-console-dashboard-full-access-group"]

  tags = {
    Name = "example-access-entry"
    Environment = "production"
  }
}

# Output the access entry ID
output "access_entry_id" {
  description = "The ID of the EKS access entry"
  value       = aws_eks_access_entry.example.id
}
</iac_template>

This Terraform configuration creates an EKS access entry with the following specifications:

1. Uses the AWS provider configured for the us-west-2 region
2. Defines variables for the cluster name and principal ARN with default values
3. Creates an EKS access entry resource named "example" with:
   - STANDARD access type
   - Specified Kubernetes groups for access control
   - Associated tags for better resource management
4. Includes an output to display the access entry ID

To use this configuration with different values, you can override the default variables by:
- Creating a terraform.tfvars file
- Passing variables on the command line
- Setting environment variables

The configuration grants the specified principal access to the EKS cluster with standard permissions and assigns them to specific Kubernetes groups for access control.