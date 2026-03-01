provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexBotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_bot_policy" {
  name   = "LexBotPolicy"
  role   = aws_iam_role.lex_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "polly:SynthesizeSpeech",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "example_bot" {
  name        = "ExampleBot"
  description = "A simple example Lex bot"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name    = "HelloWorldIntent"
    intent_version = "$LATEST"
  }
}

resource "aws_lex_intent" "hello_world_intent" {
  name        = "HelloWorldIntent"
  description = "An intent to say hello"
  sample_utterances = [
    "Hello",
    "Hi",
    "Hey"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}