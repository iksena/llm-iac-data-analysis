Description:
This Terraform configuration creates an AWS IAM role named "demo" with the name attribute set to "eks-cluster-demo". The IAM role is configured to allow EKS services to assume the role by specifying "eks.amazonaws.com" as the trusted service principal. The configuration also attaches the AWS managed policy "AmazonEKSClusterPolicy" to the role to allow necessary EKS permissions.

It then creates an AWS EKS cluster named "demo" in the us-east-1 region. The cluster's VPC configuration uses a list of subnet IDs provided via a variable (with default sample subnet IDs). The creation of the EKS cluster explicitly depends on the successful attachment of the IAM role policy, ensuring proper dependency handling. 

Below is the complete Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster VPC."
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}

resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "demo" {
  role       = aws_iam_role.demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo
  ]
}
</iac_template>