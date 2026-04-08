resource "aws_workspacesweb_ip_access_settings" "this" {
  display_name                  = var.display_name
  description                   = var.description
  customer_managed_key          = var.customer_managed_key
  additional_encryption_context = var.additional_encryption_context
  region                        = var.region
  tags                          = var.tags

  dynamic "ip_rule" {
    for_each = var.ip_rules
    content {
      ip_range    = ip_rule.value.ip_range
      description = ip_rule.value.description
    }
  }
}