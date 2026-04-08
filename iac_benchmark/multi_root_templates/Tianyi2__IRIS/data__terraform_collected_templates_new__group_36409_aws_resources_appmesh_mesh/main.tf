resource "aws_appmesh_mesh" "this" {
  region = var.region
  name   = var.name

  dynamic "spec" {
    for_each = var.spec != null ? [var.spec] : []
    content {
      dynamic "egress_filter" {
        for_each = spec.value.egress_filter != null ? [spec.value.egress_filter] : []
        content {
          type = egress_filter.value.type
        }
      }

      dynamic "service_discovery" {
        for_each = spec.value.service_discovery != null ? [spec.value.service_discovery] : []
        content {
          ip_preference = service_discovery.value.ip_preference
        }
      }
    }
  }

  tags = var.tags
}