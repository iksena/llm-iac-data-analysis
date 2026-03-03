The Terraform program will define an AWS EKS cluster using a variable for the cluster name. It will create an IAM role with the necessary policies for managing the EKS cluster. The EKS cluster will be configured with VPC subnet IDs for networking. The program will use local-exec provisioners to manage the kubectl configuration during the creation and destruction of the cluster. The IAM role will have policies attached to allow the EKS cluster to function properly.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_role" {
  name               = "${var.cluster_name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnet" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${self.name} --region ${var.region}"
  }
}

resource "null_resource" "kubectl_config_cleanup" {
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl config delete-cluster ${aws_eks_cluster.eks_cluster.name}"
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
```
</iac_template>