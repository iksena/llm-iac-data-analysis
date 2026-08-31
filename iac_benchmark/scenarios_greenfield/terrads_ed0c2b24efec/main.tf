locals {
  owners      = var.office
  environment = var.environment
  name        = "${var.office}-${var.environment}"

  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
  # eks_cluster_name = "${local.name}-${var.cluster_name}"
}

resource "aws_eks_cluster" "eks_cluster" {
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]

  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = local.effective_public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  # access_config {
  #   authentication_mode                         = "CONFIG_MAP"
  #   bootstrap_cluster_creator_admin_permissions = true
  # }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# resource "aws_cloudwatch_log_group" "eks_cluster" {
#   # The log group name format is /aws/eks/<cluster-name>/cluster
#   # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
#   name              = "/aws/eks/${var.cluster_name}/cluster"
#   retention_in_days = 7

#   # ... potentially other configuration ...
# }