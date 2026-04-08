resource "aws_secretsmanager_secret_rotation" "this" {
  region              = var.region
  secret_id           = var.secret_id
  rotate_immediately  = var.rotate_immediately
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_rules_automatically_after_days
    duration                 = var.rotation_rules_duration
    schedule_expression      = var.rotation_rules_schedule_expression
  }
}