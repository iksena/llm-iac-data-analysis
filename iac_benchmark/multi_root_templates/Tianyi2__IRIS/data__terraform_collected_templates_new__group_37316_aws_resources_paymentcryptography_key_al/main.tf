resource "aws_paymentcryptography_key_alias" "this" {
  alias_name = var.alias_name
  key_arn    = var.key_arn
  region     = var.region
}