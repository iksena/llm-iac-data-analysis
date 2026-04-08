resource "aws_xray_encryption_config" "this" {
  region = var.region
  type   = var.type
  key_id = var.key_id
}