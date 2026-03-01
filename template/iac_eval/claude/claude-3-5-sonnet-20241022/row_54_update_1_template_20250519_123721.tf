provider "aws" {
  region = "us-west-2"
}

# Create an IAM role for Amazon Connect
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

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "connect_policy" {
  role       = aws_iam_role.connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonConnectServiceRole"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "kids_connect" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias         = "kids-connect-instance"
  outbound_calls_enabled = true
}

# Create Lex Bot
resource "aws_lex_bot" "kids_bot" {
  name = "KidsHelperBot"
  description = "A bot designed to help kids"
  
  abort_statement {
    message {
      content      = "Sorry, I couldn't understand. Could you try again?"
      content_type = "PlainText"
    }
  }

  child_directed = true
  
  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you. Can you please repeat that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  
  intent {
    intent_name    = "HelloIntent"
    intent_version = "1"
  }

  process_behavior = "BUILD"
  voice_id        = "Ivy"
}

# Create Lex Bot Version
resource "aws_lex_bot_version" "kids_bot_version" {
  name    = aws_lex_bot.kids_bot.name
  version = "1"
}

# Create Lex Bot Alias
resource "aws_lex_bot_alias" "kids_bot_alias" {
  bot_name    = aws_lex_bot.kids_bot.name
  bot_version = aws_lex_bot_version.kids_bot_version.version
  description = "Production bot alias"
  name        = "KidsHelperBotAlias"
}

# Create the Connect Bot Association
resource "aws_connect_bot_association" "kids_bot_association" {
  instance_id = aws_connect_instance.kids_connect.id
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lex_bot.kids_bot.name
  }
}

# Variables with default values
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}