resource "aws_kms_replica_external_key" "this" {
  region                             = var.region
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enabled                            = var.enabled
  key_material_base64                = var.key_material_base64
  policy                             = var.policy
  primary_key_arn                    = var.primary_key_arn
  tags                               = var.tags
  valid_to                           = var.valid_to
}