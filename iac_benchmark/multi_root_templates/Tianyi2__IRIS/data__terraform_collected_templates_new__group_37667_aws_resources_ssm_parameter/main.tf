resource "aws_ssm_parameter" "this" {
  name             = var.name
  type             = var.type
  region           = var.region
  allowed_pattern  = var.allowed_pattern
  data_type        = var.data_type
  description      = var.description
  insecure_value   = var.insecure_value
  key_id           = var.key_id
  overwrite        = var.overwrite
  tags             = var.tags
  tier             = var.tier
  value            = var.value
  value_wo         = var.value_wo
  value_wo_version = var.value_wo_version
}