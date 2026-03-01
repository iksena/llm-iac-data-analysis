The Terraform configuration will set up an AWS IAM role named `demo_eks` that can be assumed by Amazon EKS services. This role will have the necessary policies attached, specifically `AmazonEKSClusterPolicy` and `AmazonEKSVPCResourceController`, to manage EKS clusters and VPC resources. Additionally, the configuration will create an Amazon EKS cluster named `demo_eks` within a specified VPC. The VPC will be configured with subnets and an internet gateway to support the EKS cluster. Proper dependencies will be managed to ensure that the IAM role permissions are in place before the EKS cluster is created.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "demo_eks" {
  name = "demo_eks"

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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.demo_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.demo_eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
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

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_eks_cluster" "demo_eks" {
  name     = "demo_eks"
  role_arn = aws_iam_role.demo_eks.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]
}
```
</iac_template>