data "aws_lex_intent" "this" {
  region  = var.region
  name    = var.name
  version = var.intent_version
}