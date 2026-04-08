resource "aws_storagegateway_file_system_association" "this" {
  region                = var.region
  gateway_arn           = var.gateway_arn
  location_arn          = var.location_arn
  username              = var.username
  password              = var.password
  audit_destination_arn = var.audit_destination_arn

  dynamic "cache_attributes" {
    for_each = var.cache_attributes != null ? [var.cache_attributes] : []
    content {
      cache_stale_timeout_in_seconds = cache_attributes.value.cache_stale_timeout_in_seconds
    }
  }

  tags = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}