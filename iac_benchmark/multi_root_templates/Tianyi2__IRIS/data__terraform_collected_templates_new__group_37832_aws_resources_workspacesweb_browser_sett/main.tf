resource "aws_workspacesweb_browser_settings" "this" {
  browser_policy                = var.browser_policy
  region                        = var.region
  additional_encryption_context = var.additional_encryption_context
  customer_managed_key          = var.customer_managed_key
  tags                          = var.tags
}