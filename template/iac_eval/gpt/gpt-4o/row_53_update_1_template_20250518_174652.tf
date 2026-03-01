provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connect_instance_role" {
  name = "ConnectInstanceRole"

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

resource "aws_iam_role_policy" "connect_instance_policy" {
  name = "ConnectInstancePolicy"
  role = aws_iam_role.connect_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lex:PostText",
          "lex:PostContent",
          "lex:RecognizeText",
          "lex:RecognizeUtterance"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_connect_instance" "example" {
  identity_management_type = "CONNECT_MANAGED"
  instance_alias           = "example-connect-instance"
}

resource "aws_lex_bot" "example" {
  name        = "ExampleLexBot"
  description = "An example Lex bot"
  locale      = "en-US"
  child_directed = false

  intents {
    intent_name = "HelloWorldIntent"
    sample_utterances = ["Hello", "Hi", "Hey"]
    fulfillment_activity {
      type = "ReturnIntent"
    }
  }
}

resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  lex_bot {
    name   = aws_lex_bot.example.name
    region = "us-east-1"
  }
}