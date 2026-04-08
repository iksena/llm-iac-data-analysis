resource "aws_neptune_cluster_endpoint" "this" {
  region                      = var.region
  cluster_identifier          = var.cluster_identifier
  cluster_endpoint_identifier = var.cluster_endpoint_identifier
  endpoint_type               = var.endpoint_type
  excluded_members            = var.excluded_members
  static_members              = var.static_members
  tags                        = var.tags
}