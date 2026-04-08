resource "aws_rum_app_monitor" "this" {
  name           = var.name
  region         = var.region
  cw_log_enabled = var.cw_log_enabled
  domain         = var.app_monitor_configuration != null ? var.app_monitor_configuration.domain : null
  domain_list    = var.app_monitor_configuration != null ? var.app_monitor_configuration.domain_list : null
  tags           = var.tags

  dynamic "app_monitor_configuration" {
    for_each = var.app_monitor_configuration != null ? [var.app_monitor_configuration] : []
    content {
      allow_cookies       = app_monitor_configuration.value.allow_cookies
      enable_xray         = app_monitor_configuration.value.enable_xray
      excluded_pages      = app_monitor_configuration.value.excluded_pages
      favorite_pages      = app_monitor_configuration.value.favorite_pages
      guest_role_arn      = app_monitor_configuration.value.guest_role_arn
      identity_pool_id    = app_monitor_configuration.value.identity_pool_id
      included_pages      = app_monitor_configuration.value.included_pages
      session_sample_rate = app_monitor_configuration.value.session_sample_rate
      telemetries         = app_monitor_configuration.value.telemetries
    }
  }

  dynamic "custom_events" {
    for_each = var.custom_events != null ? [var.custom_events] : []
    content {
      status = custom_events.value.status
    }
  }
}