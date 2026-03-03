provider "aws" {
  region = "us-west-2"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "example" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias          = "kids-connect-instance"
  outbound_calls_enabled  = true
}

# Create the Connect Bot Association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id

  lexv2_bot {
    alias_arn = var.lex_bot_alias_arn
  }
}

# Required variable for Lex bot alias ARN
variable "lex_bot_alias_arn" {
  type        = string
  description = "The ARN of the Lex V2 bot alias"
  default     = "arn:aws:lex:us-west-2:123456789012:bot-alias/ABCDEFGHIJ/KLMNOPQRST"
}