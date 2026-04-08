data "aws_secretsmanager_secret_rotation" "this" {
  region    = var.region
  secret_id = var.secret_id
}