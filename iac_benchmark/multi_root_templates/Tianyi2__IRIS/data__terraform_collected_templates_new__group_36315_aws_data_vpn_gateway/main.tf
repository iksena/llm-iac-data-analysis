data "aws_vpn_gateway" "this" {
  region            = var.region
  id                = var.id
  state             = var.state
  availability_zone = var.availability_zone
  attached_vpc_id   = var.attached_vpc_id
  tags              = var.tags
  amazon_side_asn   = var.amazon_side_asn

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = "20m"
  }
}