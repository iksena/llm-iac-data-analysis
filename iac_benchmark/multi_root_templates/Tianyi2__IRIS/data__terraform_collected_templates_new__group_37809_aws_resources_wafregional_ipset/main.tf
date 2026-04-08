resource "aws_wafregional_ipset" "this" {
  region = var.region
  name   = var.name

  dynamic "ip_set_descriptor" {
    for_each = var.ip_set_descriptor
    content {
      type  = ip_set_descriptor.value.type
      value = ip_set_descriptor.value.value
    }
  }
}