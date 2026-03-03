The Terraform program will set up an AWS IAM role named 'eks-cluster' specifically for an Amazon EKS cluster. This role will have an assume role policy that allows EKS services to assume the role. The AmazonEKSClusterPolicy will be attached to this role to provide the necessary permissions. Additionally, the program will create an AWS EKS cluster with specified name and version, and it will be attached to a specified subnet and VPC in the us-east-1 region. The EKS cluster will have its endpoint private access set to false and public access set to true. Proper dependency handling will ensure that the IAM role's policy attachment is completed before the EKS cluster is created.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster"

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
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-eks-cluster"
  version  = "1.21"

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = ["subnet-0123456789abcdef0"] # Replace with your actual subnet ID
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment
  ]
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  default     = "vpc-0123456789abcdef0" # Replace with your actual VPC ID
}
```
</iac_template>