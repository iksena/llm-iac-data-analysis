provider "aws" {
  region = "us-west-2"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "example" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias          = "example-connect-instance"
  outbound_calls_enabled  = true
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_bot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lexv2_bot" "example" {
  name = "ExampleBot"
  
  data_privacy {
    child_directed = false
  }
  
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  bot_locale {
    locale_id = "en_US"
    nlu_intent_confidence_threshold = 0.40
  }
}

# Create Connect Bot Association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lexv2_bot.example.name
  }
}