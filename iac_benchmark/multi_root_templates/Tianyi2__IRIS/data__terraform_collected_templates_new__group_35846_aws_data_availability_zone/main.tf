data "aws_availability_zone" "this" {
  region                 = var.region
  all_availability_zones = var.all_availability_zones
  name                   = var.name
  state                  = var.state
  zone_id                = var.zone_id

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