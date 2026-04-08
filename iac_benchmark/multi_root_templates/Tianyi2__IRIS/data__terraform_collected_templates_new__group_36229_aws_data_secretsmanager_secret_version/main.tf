data "aws_secretsmanager_secret_version" "this" {
  region        = var.region
  secret_id     = var.secret_id
  version_id    = var.version_id
  version_stage = var.version_stage
}