I apologize for the confusion. You're right. Let me correct this. The resource type should be "aws_eks_access_policy_association" instead of "aws_eks_access_entry" for managing EKS access.

Here's the corrected template:

<iac_template>
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

# EKS Access Policy Association
resource "aws_eks_access_policy_association" "example" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}
</iac_template>

This template:
1. Uses the correct resource type `aws_eks_access_policy_association`
2. Associates an EKS cluster access policy with a principal
3. Uses the AmazonEKSClusterAdminPolicy as the default policy
4. Specifies the cluster name and principal ARN
5. Removes the unsupported attributes from the previous version

The configuration will grant administrative access to the specified EKS cluster for the given principal ARN.