resource "aws_codeartifact_domain_permissions_policy" "this" {
  domain          = var.domain
  policy_document = var.policy_document
  domain_owner    = var.domain_owner
  policy_revision = var.policy_revision
}