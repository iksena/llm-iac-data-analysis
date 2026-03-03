The Terraform configuration will create an AWS IAM role named "eks-cluster-demo" that is specifically designed for an Amazon EKS cluster. This role will have the necessary permissions to allow EKS services to assume it, and it will have the AmazonEKSClusterPolicy attached. Additionally, the configuration will set up an Amazon EKS cluster named "demo" in the us-east-1 region. The EKS cluster will be configured to use specified subnet IDs for its VPC. The configuration will ensure that the IAM role's policy attachment is properly handled as a dependency during the EKS cluster management.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}
```
</iac_template>