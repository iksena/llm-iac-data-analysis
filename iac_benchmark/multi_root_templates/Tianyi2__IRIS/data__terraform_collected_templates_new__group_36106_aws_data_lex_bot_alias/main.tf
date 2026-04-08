data "aws_lex_bot_alias" "this" {
  region   = var.region
  bot_name = var.bot_name
  name     = var.name
}