data "aws_fsx_openzfs_snapshot" "this" {
  region       = var.region
  most_recent  = var.most_recent
  snapshot_ids = var.snapshot_ids

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}