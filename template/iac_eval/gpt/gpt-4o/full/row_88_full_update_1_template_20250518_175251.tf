To fulfill the business need, we will create an IAM role named 'eks-cluster-1' with an assume role policy that allows the 'eks.amazonaws.com' service to assume the role. We will attach the 'AmazonEKSClusterPolicy' IAM policy to this role. Additionally, we will define an AWS EKS cluster using a variable for the cluster name and specify the version. The EKS cluster will be associated with the created IAM role and configured to use a VPC with specified subnet IDs for networking, including both private and public subnets. The configuration will be set in a specified AWS region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-1"

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

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.21"
}

variable "vpc_id" {
  description = "The VPC ID for the EKS cluster"
  type        = string
  default     = "vpc-12345678"
}

variable "subnet_ids" {
  description = "The subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"]
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}
```
</iac_template>