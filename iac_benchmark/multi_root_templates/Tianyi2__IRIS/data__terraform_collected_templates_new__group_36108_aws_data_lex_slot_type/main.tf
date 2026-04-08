data "aws_lex_slot_type" "this" {
  region  = var.region
  name    = var.name
  version = var.slot_version
}