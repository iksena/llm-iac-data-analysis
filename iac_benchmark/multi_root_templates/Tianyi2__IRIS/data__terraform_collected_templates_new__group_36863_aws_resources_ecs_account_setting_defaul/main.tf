resource "aws_ecs_account_setting_default" "this" {
  region = var.region
  name   = var.name
  value  = var.value
}