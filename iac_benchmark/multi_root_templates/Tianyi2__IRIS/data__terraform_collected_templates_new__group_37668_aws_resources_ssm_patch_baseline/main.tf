resource "aws_ssm_patch_baseline" "this" {
  name                                         = var.name
  description                                  = var.description
  operating_system                             = var.operating_system
  approved_patches                             = var.approved_patches
  approved_patches_compliance_level            = var.approved_patches_compliance_level
  approved_patches_enable_non_security         = var.approved_patches_enable_non_security
  available_security_updates_compliance_status = var.available_security_updates_compliance_status
  rejected_patches                             = var.rejected_patches
  rejected_patches_action                      = var.rejected_patches_action
  tags                                         = var.tags

  dynamic "approval_rule" {
    for_each = var.approval_rules
    content {
      approve_after_days  = approval_rule.value.approve_after_days
      approve_until_date  = approval_rule.value.approve_until_date
      compliance_level    = approval_rule.value.compliance_level
      enable_non_security = approval_rule.value.enable_non_security

      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_filters
        content {
          key    = patch_filter.value.key
          values = patch_filter.value.values
        }
      }
    }
  }

  dynamic "global_filter" {
    for_each = var.global_filters
    content {
      key    = global_filter.value.key
      values = global_filter.value.values
    }
  }

  dynamic "source" {
    for_each = var.sources
    content {
      configuration = source.value.configuration
      name          = source.value.name
      products      = source.value.products
    }
  }
}