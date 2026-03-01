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
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lex_bot" "example" {
  name = "ExampleBot"
  description = "Example bot for Connect integration"
  
  abort_statement {
    message {
      content      = "Sorry, I could not help you."
      content_type = "PlainText"
    }
  }

  child_directed = false
  
  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you, could you please repeat that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  process_behavior            = "BUILD"
  voice_id                    = "Joanna"
}

# Create Connect Bot Association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lex_bot.example.name
  }
}