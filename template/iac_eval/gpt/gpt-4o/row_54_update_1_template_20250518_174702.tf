provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connect_service_role" {
  name = "ConnectServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "connect_service_policy" {
  name   = "ConnectServicePolicy"
  role   = aws_iam_role.connect_service_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "lex:PostText",
          "lex:PostContent"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_connect_instance" "connect_instance" {
  identity_management_type = "CONNECT_MANAGED"
  instance_alias           = "KidsConnectInstance"
}

resource "aws_lex_bot" "kids_lex_bot" {
  name        = "KidsLexBot"
  description = "A Lex bot for kids"
  locale      = "en-US"
  child_directed = true

  # Define intents and other bot configurations here
}

resource "aws_connect_bot_association" "bot_association" {
  instance_id = aws_connect_instance.connect_instance.id
  lex_bot {
    name     = aws_lex_bot.kids_lex_bot.name
    lex_region = "us-east-1"
  }
}