resource "aws_ecr_account_setting" "this" {
  region = var.region
  name   = var.name
  value  = var.value
}