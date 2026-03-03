To fulfill the business need, we will create a Terraform script that configures access to an AWS EKS cluster. The script will define an IAM role that grants access to the EKS cluster named "example". The access will be granted to a specific principal identified by their ARN. Additionally, we will assign the principal to specific Kubernetes groups and set the access type to 'STANDARD'. The configuration will include the necessary AWS provider setup and IAM role creation.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

variable "eks_cluster_name" {
  default = "example"
}

variable "principal_arn" {
  description = "The ARN of the principal to grant access to the EKS cluster."
  default     = "arn:aws:iam::123456789012:user/example-user"
}

variable "kubernetes_groups" {
  description = "The Kubernetes groups to assign to the principal."
  type        = list(string)
  default     = ["system:masters"]
}

resource "aws_iam_role" "eks_access_role" {
  name = "eks-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.principal_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eks_access_policy" {
  name = "eks-access-policy"
  role = aws_iam_role.eks_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_eks_cluster" "example" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_access_role.arn

  vpc_config {
    subnet_ids = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]
  }
}

resource "aws_eks_node_group" "example_nodes" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example-nodes"
  node_role_arn   = aws_iam_role.eks_access_role.arn
  subnet_ids      = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

resource "aws_auth_config_map" "eks_auth" {
  cluster_name = aws_eks_cluster.example.name

  map_roles = [
    {
      rolearn  = aws_iam_role.eks_access_role.arn
      username = "eks-user"
      groups   = var.kubernetes_groups
    }
  ]
}
```

</iac_template>

This Terraform script sets up an EKS cluster named "example" and configures IAM roles and policies to allow a specified principal to access the cluster. The principal is assigned to Kubernetes groups specified in the `kubernetes_groups` variable, and the access type is set to 'STANDARD' by allowing necessary EKS actions.