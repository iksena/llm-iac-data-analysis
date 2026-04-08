resource "aws_ecr_pull_through_cache_rule" "this" {
  region                     = var.region
  credential_arn             = var.credential_arn
  custom_role_arn            = var.custom_role_arn
  ecr_repository_prefix      = var.ecr_repository_prefix
  upstream_registry_url      = var.upstream_registry_url
  upstream_repository_prefix = var.upstream_repository_prefix
}