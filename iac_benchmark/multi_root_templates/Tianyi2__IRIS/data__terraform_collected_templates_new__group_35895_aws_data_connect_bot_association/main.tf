data "aws_connect_bot_association" "this" {
  region      = var.region
  instance_id = var.instance_id

  lex_bot {
    name       = var.lex_bot_name
    lex_region = var.lex_bot_lex_region
  }
}