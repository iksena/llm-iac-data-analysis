resource "aws_waf_ipset" "this" {
  name = var.name

  dynamic "ip_set_descriptors" {
    for_each = var.ip_set_descriptors != null ? var.ip_set_descriptors : []
    content {
      type  = ip_set_descriptors.value.type
      value = ip_set_descriptors.value.value
    }
  }
}