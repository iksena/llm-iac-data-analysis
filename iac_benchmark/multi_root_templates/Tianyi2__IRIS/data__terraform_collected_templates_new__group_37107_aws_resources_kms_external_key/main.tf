resource "aws_kms_external_key" "this" {
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.enabled
  key_material_base64                = var.key_material_base64
  key_spec                           = var.key_spec
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  policy                             = var.policy
  region                             = var.region
  tags                               = var.tags
  valid_to                           = var.valid_to
}