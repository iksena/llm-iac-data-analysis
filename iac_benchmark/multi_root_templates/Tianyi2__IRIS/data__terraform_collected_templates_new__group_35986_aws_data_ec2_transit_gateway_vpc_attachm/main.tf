data "aws_ec2_transit_gateway_vpc_attachment" "this" {
  region = var.region
  id     = var.id

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