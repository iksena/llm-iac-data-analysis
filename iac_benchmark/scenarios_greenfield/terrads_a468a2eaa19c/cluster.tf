#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

# IAM role and policy to allow the EKS service to manage or retrieve
# data from other AWS services.
resource "aws_iam_role" "cluster_iam" {
  name = "eks-iam-${var.customer_name}-${var.cluster_name}" 

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

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_iam.name
}

# security group controls networking access to the Kubernetes masters. 
# later this will be configured with an ingress rule to allow traffic from the worker nodes.
resource "aws_security_group" "cluster-secgrp" {
  name = "eks-secgrp-${var.customer_name}-${var.cluster_name}" 
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc_id.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-secgrp-${var.customer_name}-${var.cluster_name}" 
  }
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-secgrp.id
  to_port           = 443
  type              = "ingress"
}

locals {
  private_subnet_list = aws_subnet.private_subnet[*].id
  subnet_list = concat(local.private_subnet_list, [aws_subnet.public_subnet.id])
} 

resource "aws_eks_cluster" "cluster" {
  name     = "${var.customer_name}-${var.cluster_name}"
  role_arn = aws_iam_role.cluster_iam.arn
  version = "${var.cluster_version}"

  vpc_config {
    security_group_ids = [aws_security_group.cluster-secgrp.id]
    subnet_ids         = local.subnet_list 
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

### OIDC config
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [join("", data.tls_certificate.cluster.*.certificates.0.sha1_fingerprint)]
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
