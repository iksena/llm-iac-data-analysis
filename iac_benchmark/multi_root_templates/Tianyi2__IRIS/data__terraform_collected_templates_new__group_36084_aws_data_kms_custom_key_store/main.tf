data "aws_kms_custom_key_store" "this" {
  region                = var.region
  custom_key_store_id   = var.custom_key_store_id
  custom_key_store_name = var.custom_key_store_name
}