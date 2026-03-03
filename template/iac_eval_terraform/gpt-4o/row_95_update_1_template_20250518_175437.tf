provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster" "example" {
  name = "example"
}

data "aws_eks_cluster_auth" "example" {
  name = data.aws_eks_cluster.example.name
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_eks_cluster.example.vpc_config[0].vpc_id
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = data.aws_eks_cluster.example.name
  fargate_profile_name   = "example-fargate-profile"
  pod_execution_role_arn = aws_iam_role.example.arn
  subnet_ids             = data.aws_subnet_ids.all.ids

  selector {
    namespace = "example"
  }
}