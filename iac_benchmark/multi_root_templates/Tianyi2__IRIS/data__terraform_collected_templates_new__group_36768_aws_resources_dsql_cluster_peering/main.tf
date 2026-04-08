resource "aws_dsql_cluster_peering" "this" {
  clusters       = var.clusters
  identifier     = var.identifier
  region         = var.region
  witness_region = var.witness_region

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
    }
  }
}