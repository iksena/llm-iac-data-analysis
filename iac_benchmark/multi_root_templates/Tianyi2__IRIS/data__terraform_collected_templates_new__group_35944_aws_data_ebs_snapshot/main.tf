data "aws_ebs_snapshot" "this" {
  region                 = var.region
  most_recent            = var.most_recent
  owners                 = var.owners
  snapshot_ids           = var.snapshot_ids
  restorable_by_user_ids = var.restorable_by_user_ids

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts.read
  }
}