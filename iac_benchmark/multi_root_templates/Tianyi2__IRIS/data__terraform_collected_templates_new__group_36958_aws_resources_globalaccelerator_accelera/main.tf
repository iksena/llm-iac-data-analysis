resource "aws_globalaccelerator_accelerator" "this" {
  name            = var.name
  ip_address_type = var.ip_address_type
  ip_addresses    = var.ip_addresses
  enabled         = var.enabled
  tags            = var.tags

  dynamic "attributes" {
    for_each = var.attributes != null ? [var.attributes] : []
    content {
      flow_logs_enabled   = attributes.value.flow_logs_enabled
      flow_logs_s3_bucket = attributes.value.flow_logs_s3_bucket
      flow_logs_s3_prefix = attributes.value.flow_logs_s3_prefix
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}