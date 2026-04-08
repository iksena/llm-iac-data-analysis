data "aws_vpc_endpoint_service" "this" {
  count           = var.service != null || var.service_name != null || length(var.filter) > 0 ? 1 : 0
  service         = var.service
  service_name    = var.service_name
  service_regions = var.service_regions
  service_type    = var.service_type
  tags            = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts_read
  }
}