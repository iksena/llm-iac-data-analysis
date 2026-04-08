data "aws_lex_bot" "this" {
  name    = var.name
  version = var.bot_version
  region  = var.region
}