resource "aws_cloudtrail_event_data_store" "this" {
  name                           = var.name
  region                         = var.region
  billing_mode                   = var.billing_mode
  suspend                        = var.suspend
  multi_region_enabled           = var.multi_region_enabled
  organization_enabled           = var.organization_enabled
  retention_period               = var.retention_period
  kms_key_id                     = var.kms_key_id
  tags                           = var.tags
  termination_protection_enabled = var.termination_protection_enabled

  dynamic "advanced_event_selector" {
    for_each = var.advanced_event_selectors
    content {
      name = advanced_event_selector.value.name

      dynamic "field_selector" {
        for_each = advanced_event_selector.value.field_selectors
        content {
          field           = field_selector.value.field
          equals          = field_selector.value.equals
          not_equals      = field_selector.value.not_equals
          starts_with     = field_selector.value.starts_with
          not_starts_with = field_selector.value.not_starts_with
          ends_with       = field_selector.value.ends_with
          not_ends_with   = field_selector.value.not_ends_with
        }
      }
    }
  }
}