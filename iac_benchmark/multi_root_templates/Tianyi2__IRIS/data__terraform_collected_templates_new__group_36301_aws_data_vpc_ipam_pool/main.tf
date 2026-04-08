data "aws_vpc_ipam_pool" "this" {
  region       = var.region
  ipam_pool_id = var.ipam_pool_id

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.read_timeout
  }
}