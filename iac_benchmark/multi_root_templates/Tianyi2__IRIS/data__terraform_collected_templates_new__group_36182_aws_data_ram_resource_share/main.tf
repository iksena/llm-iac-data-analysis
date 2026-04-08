data "aws_ram_resource_share" "this" {
  region                = var.region
  name                  = var.name
  resource_owner        = var.resource_owner
  resource_share_status = var.resource_share_status

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}