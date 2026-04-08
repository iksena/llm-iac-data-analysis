resource "aws_key_pair" "this" {
  region          = var.region
  key_name        = var.key_name
  key_name_prefix = var.key_name_prefix
  public_key      = var.public_key
  tags            = var.tags
}