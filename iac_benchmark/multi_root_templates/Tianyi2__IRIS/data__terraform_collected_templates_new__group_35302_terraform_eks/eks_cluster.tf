resource "aws_iam_role" "eks_cluster" {
  name = "terraform-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-EKSpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster-EKSsvcpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks_project" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    security_group_ids = [ aws_security_group.security_group_eks_cluster.id ]
    subnet_ids         = var.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-EKSpolicy,
    aws_iam_role_policy_attachment.cluster-EKSsvcpolicy,
  ]
}
