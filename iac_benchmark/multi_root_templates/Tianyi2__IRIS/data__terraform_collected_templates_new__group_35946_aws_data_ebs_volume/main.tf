data "aws_ebs_volume" "this" {
  region      = var.region
  most_recent = var.most_recent

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}