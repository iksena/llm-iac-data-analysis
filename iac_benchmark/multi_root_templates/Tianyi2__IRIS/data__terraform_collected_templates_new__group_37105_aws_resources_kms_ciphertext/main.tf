resource "aws_kms_ciphertext" "this" {
  region    = var.region
  plaintext = var.plaintext
  key_id    = var.key_id
  context   = var.context
}