To fulfill the business need, I will create a Terraform script that provisions an AWS EKS cluster named "example". The script will define the necessary resources, including the EKS cluster and an associated IAM role with the required policy attachments. The VPC settings will be configured with specific subnet IDs. Additionally, the script will include outputs for the cluster's endpoint and the kubeconfig certificate authority data.

The Terraform configuration will include:
- AWS provider configuration.
- An IAM role for the EKS cluster with the necessary policy attachments.
- An EKS cluster resource with the specified name and associated IAM role ARN.
- VPC settings with specified subnet IDs.
- Outputs for the EKS cluster's endpoint and kubeconfig certificate authority data.

Here is the complete Terraform HCL template:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "example-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}
```
</iac_template>

This configuration sets up an EKS cluster with the necessary IAM roles and policies, configures the VPC with specified subnet IDs, and provides outputs for the cluster's endpoint and certificate authority data.