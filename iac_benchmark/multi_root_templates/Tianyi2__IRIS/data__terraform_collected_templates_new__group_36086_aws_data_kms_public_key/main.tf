data "aws_kms_public_key" "this" {
  key_id       = var.key_id
  region       = var.region
  grant_tokens = var.grant_tokens
}