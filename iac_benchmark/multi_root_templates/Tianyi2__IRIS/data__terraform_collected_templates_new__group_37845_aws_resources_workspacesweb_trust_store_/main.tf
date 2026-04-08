resource "aws_workspacesweb_trust_store_association" "this" {
  trust_store_arn = var.trust_store_arn
  portal_arn      = var.portal_arn
  region          = var.region
}