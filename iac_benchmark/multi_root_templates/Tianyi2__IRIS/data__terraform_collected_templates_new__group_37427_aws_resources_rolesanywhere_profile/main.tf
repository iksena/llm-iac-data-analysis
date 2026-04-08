resource "aws_rolesanywhere_profile" "this" {
  duration_seconds            = var.duration_seconds
  enabled                     = var.enabled
  managed_policy_arns         = var.managed_policy_arns
  name                        = var.name
  require_instance_properties = var.require_instance_properties
  role_arns                   = var.role_arns
  session_policy              = var.session_policy
  tags                        = var.tags
}