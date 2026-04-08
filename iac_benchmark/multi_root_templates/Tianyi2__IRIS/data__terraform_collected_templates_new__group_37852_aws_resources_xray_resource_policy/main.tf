resource "aws_xray_resource_policy" "this" {
  policy_name                 = var.policy_name
  policy_document             = var.policy_document
  region                      = var.region
  policy_revision_id          = var.policy_revision_id
  bypass_policy_lockout_check = var.bypass_policy_lockout_check
}