resource "aws_lakeformation_resource" "this" {
  arn                     = var.arn
  region                  = var.region
  role_arn                = var.role_arn
  use_service_linked_role = var.use_service_linked_role
  hybrid_access_enabled   = var.hybrid_access_enabled
  with_federation         = var.with_federation
  with_privileged_access  = var.with_privileged_access
}