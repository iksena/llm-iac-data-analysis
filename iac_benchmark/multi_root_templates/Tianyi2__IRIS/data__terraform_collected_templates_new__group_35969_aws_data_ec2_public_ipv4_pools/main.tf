data "aws_ec2_public_ipv4_pools" "this" {
  region = var.region
  tags   = var.tags

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}