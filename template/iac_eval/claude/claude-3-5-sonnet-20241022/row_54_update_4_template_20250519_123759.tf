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

  lex_bot {
    name        = var.lex_bot_name
    lex_region  = "us-west-2"
  }
}

# Required variable for Lex bot name
variable "lex_bot_name" {
  type        = string
  description = "The name of the Lex bot"
  default     = "KidsHelperBot"
}