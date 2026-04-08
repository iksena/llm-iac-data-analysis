resource "aws_workspacesweb_identity_provider" "this" {
  identity_provider_details = var.identity_provider_details
  identity_provider_name    = var.identity_provider_name
  identity_provider_type    = var.identity_provider_type
  portal_arn                = var.portal_arn
  region                    = var.region
  tags                      = var.tags
}