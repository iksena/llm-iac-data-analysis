resource "aws_secretsmanager_secret_policy" "this" {
  policy              = var.policy
  secret_arn          = var.secret_arn
  region              = var.region
  block_public_policy = var.block_public_policy
}