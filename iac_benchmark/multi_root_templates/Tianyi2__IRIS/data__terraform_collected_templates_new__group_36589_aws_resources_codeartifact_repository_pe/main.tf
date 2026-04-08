resource "aws_codeartifact_repository_permissions_policy" "this" {
  region          = var.region
  repository      = var.repository
  domain          = var.domain
  policy_document = var.policy_document
  domain_owner    = var.domain_owner
  policy_revision = var.policy_revision
}