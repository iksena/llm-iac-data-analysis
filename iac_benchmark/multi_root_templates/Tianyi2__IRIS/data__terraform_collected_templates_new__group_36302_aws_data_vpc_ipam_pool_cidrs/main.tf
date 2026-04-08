data "aws_vpc_ipam_pool_cidrs" "this" {
  region       = var.region
  ipam_pool_id = var.ipam_pool_id

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