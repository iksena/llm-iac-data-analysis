resource "aws_timestreamwrite_database" "this" {
  region        = var.region
  database_name = var.database_name
  kms_key_id    = var.kms_key_id
  tags          = var.tags
}