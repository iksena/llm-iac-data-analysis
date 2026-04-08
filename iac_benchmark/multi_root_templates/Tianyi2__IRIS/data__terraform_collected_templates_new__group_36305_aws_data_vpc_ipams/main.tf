data "aws_vpc_ipams" "this" {
  region   = var.region
  ipam_ids = var.ipam_ids

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}