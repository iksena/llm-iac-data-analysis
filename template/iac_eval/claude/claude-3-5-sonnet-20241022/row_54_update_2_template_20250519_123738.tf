provider "aws" {
  region = "us-west-2"
}

# Create IAM role for Amazon Connect
resource "aws_iam_role" "connect_role" {
  name = "connect_lex_role"

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
resource "aws_iam_role_policy_attachment" "connect_lex_policy" {
  role       = aws_iam_role.connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonLexRunBotsPolicy"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "kids_connect" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias          = "kids-connect-instance"
  outbound_calls_enabled  = true
}

# Create the Connect Bot Association
resource "aws_connect_bot_association" "kids_bot_association" {
  instance_id = aws_connect_instance.kids_connect.id
  
  lexv2_bot {
    alias_arn = var.lex_bot_alias_arn
  }
}

# Variables
variable "lex_bot_alias_arn" {
  description = "ARN of the Lex V2 bot alias to associate with Connect"
  type        = string
  default     = "arn:aws:lex:us-west-2:123456789012:bot-alias/ABCDEFGHIJ/KLMNOPQRST"  # Replace with actual bot alias ARN
}