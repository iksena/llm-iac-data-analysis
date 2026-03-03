provider "aws" {
  region = "us-east-1"
}

resource "aws_connect_instance" "saml_instance" {
  identity_management_type = "SAML"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true
  instance_alias           = "my-saml-connect-instance"
}

resource "aws_connect_bot_association" "bot_assoc" {
  instance_id          = aws_connect_instance.saml_instance.id
  bot_association_name = "my-lex-bot-association"

  lex_bot {
    name       = "my-lex-bot"
    lex_region = "us-east-1"
  }
}