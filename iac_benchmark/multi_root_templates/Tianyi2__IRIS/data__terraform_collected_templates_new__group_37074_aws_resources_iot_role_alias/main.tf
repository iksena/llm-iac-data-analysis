resource "aws_iot_role_alias" "this" {
  region              = var.region
  alias               = var.alias
  role_arn            = var.role_arn
  credential_duration = var.credential_duration
  tags                = var.tags
}