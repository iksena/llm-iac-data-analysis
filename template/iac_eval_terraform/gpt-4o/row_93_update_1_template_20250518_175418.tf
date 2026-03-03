provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_addon" "example" {
  cluster_name = "my-eks-cluster"  # Replace with your actual EKS cluster name
  addon_name   = "vpc-cni"

  # Optional: Specify the addon version if needed
  # addon_version = "v1.7.5-eksbuild.1"

  # Optional: Specify the service account role ARN if needed
  # service_account_role_arn = "arn:aws:iam::123456789012:role/your-service-account-role"

  # Optional: Tags for the addon
  tags = {
    Name = "example-addon"
  }
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"  # Replace with your actual EKS cluster name
}