data "aws_redshift_orderable_cluster" "this" {
  region               = var.region
  cluster_type         = var.cluster_type
  cluster_version      = var.cluster_version
  node_type            = var.node_type
  preferred_node_types = var.preferred_node_types
}