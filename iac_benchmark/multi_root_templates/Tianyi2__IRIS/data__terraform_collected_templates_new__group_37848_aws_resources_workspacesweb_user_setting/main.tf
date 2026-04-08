resource "aws_workspacesweb_user_settings" "this" {
  copy_allowed     = var.copy_allowed
  download_allowed = var.download_allowed
  paste_allowed    = var.paste_allowed
  print_allowed    = var.print_allowed
  upload_allowed   = var.upload_allowed

  region                             = var.region
  additional_encryption_context      = var.additional_encryption_context
  customer_managed_key               = var.customer_managed_key
  deep_link_allowed                  = var.deep_link_allowed
  disconnect_timeout_in_minutes      = var.disconnect_timeout_in_minutes
  idle_disconnect_timeout_in_minutes = var.idle_disconnect_timeout_in_minutes
  tags                               = var.tags

  dynamic "cookie_synchronization_configuration" {
    for_each = var.cookie_synchronization_configuration != null ? [var.cookie_synchronization_configuration] : []
    content {
      dynamic "allowlist" {
        for_each = cookie_synchronization_configuration.value.allowlist
        content {
          domain = allowlist.value.domain
          name   = allowlist.value.name
          path   = allowlist.value.path
        }
      }

      dynamic "blocklist" {
        for_each = cookie_synchronization_configuration.value.blocklist
        content {
          domain = blocklist.value.domain
          name   = blocklist.value.name
          path   = blocklist.value.path
        }
      }
    }
  }

  dynamic "toolbar_configuration" {
    for_each = var.toolbar_configuration != null ? [var.toolbar_configuration] : []
    content {
      hidden_toolbar_items   = toolbar_configuration.value.hidden_toolbar_items
      max_display_resolution = toolbar_configuration.value.max_display_resolution
      toolbar_type           = toolbar_configuration.value.toolbar_type
      visual_mode            = toolbar_configuration.value.visual_mode
    }
  }
}