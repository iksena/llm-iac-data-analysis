data "aws_eks_node_groups" "this" {
  cluster_name = var.cluster_name
  region       = var.region
}