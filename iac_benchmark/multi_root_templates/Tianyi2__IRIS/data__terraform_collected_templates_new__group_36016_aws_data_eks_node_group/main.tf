data "aws_eks_node_group" "this" {
  region          = var.region
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
}