data "aws_secretsmanager_secret" "this" {
  region = var.region
  arn    = var.arn
  name   = var.name
}