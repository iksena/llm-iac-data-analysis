resource "aws_kms_key_policy" "this" {
  region                             = var.region
  key_id                             = var.key_id
  policy                             = var.policy
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
}