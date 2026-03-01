provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexV2BotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_bot_policy" {
  name   = "LexV2BotPolicy"
  role   = aws_iam_role.lex_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "polly:SynthesizeSpeech",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lexv2_bot" "children_bot" {
  name        = "ChildrenBot"
  role_arn    = aws_iam_role.lex_bot_role.arn
  data_privacy {
    child_directed = true
  }
  idle_session_ttl_in_seconds = 300

  intent {
    name = "GreetIntent"
    sample_utterances = [
      "Hello",
      "Hi",
      "Hey"
    ]
    fulfillment_activity {
      type = "ReturnIntent"
    }
  }
}