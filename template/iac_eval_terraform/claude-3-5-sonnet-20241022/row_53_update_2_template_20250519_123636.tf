provider "aws" {
  region = "us-west-2"
}

# Create IAM role for Amazon Connect
resource "aws_iam_role" "connect_role" {
  name = "connect_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
      }
    ]
  })
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

# Attach basic Lambda execution policy to Lex role
resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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

# Create Bot Version
resource "aws_lexv2_bot_version" "example" {
  bot_id = aws_lexv2_bot.example.id
  description = "Version 1"
}

# Create Bot Alias
resource "aws_lexv2_bot_alias" "example" {
  bot_alias_name = "TestAlias"
  bot_id         = aws_lexv2_bot.example.id
  bot_version    = aws_lexv2_bot_version.example.bot_version
}

# Create Connect Bot Association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lexv2_bot.example.name
  }
}