data "aws_kms_key" "this" {
  key_id       = var.key_id
  grant_tokens = var.grant_tokens
}