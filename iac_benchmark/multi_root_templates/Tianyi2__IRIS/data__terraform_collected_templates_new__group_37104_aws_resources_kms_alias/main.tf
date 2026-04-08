resource "aws_kms_alias" "this" {
  region        = var.region
  name          = var.name
  name_prefix   = var.name_prefix
  target_key_id = var.target_key_id
}