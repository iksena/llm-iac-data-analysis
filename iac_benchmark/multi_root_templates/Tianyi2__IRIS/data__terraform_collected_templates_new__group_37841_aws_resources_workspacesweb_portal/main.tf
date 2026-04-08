resource "aws_workspacesweb_portal" "this" {
  additional_encryption_context = var.additional_encryption_context
  authentication_type           = var.authentication_type
  browser_settings_arn          = var.browser_settings_arn
  customer_managed_key          = var.customer_managed_key
  display_name                  = var.display_name
  instance_type                 = var.instance_type
  max_concurrent_sessions       = var.max_concurrent_sessions
  region                        = var.region
  tags                          = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != {} ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}