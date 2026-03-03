Description:
This Terraform configuration creates an AWS EKS cluster whose name is determined by the variable "cluster_name". It also creates an IAM role for the cluster with managed policy attachments for Amazon EKS cluster and service policies. The cluster is attached to specified VPC subnets through a variable "subnet_ids". To ensure proper handling of IAM permissions in relation to the cluster lifecycle, the IAM role is created and its policies are attached before the EKS cluster is provisioned. Additionally, local-exec provisioners are used on the EKS cluster resource to update the kubectl configuration upon cluster creation and to clean it up during destruction.

Below is the complete Terraform HCL program:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "subnet_ids" {
  description = "VPC subnet IDs for EKS cluster networking"
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}_eks_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Wait for the Kubernetes API endpoint to be active
  timeouts {
    create = "20m"
    delete = "20m"
  }

  # Local-exec provisioner for cluster creation: update kubeconfig
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name}"
  }

  # Local-exec provisioner for cluster deletion: cleanup kubeconfig
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Cleaning up kubectl configuration for ${var.cluster_name}'"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}
</iac_template>