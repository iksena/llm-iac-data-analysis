To create an AWS Lex bot with multiple slots using Terraform, we will define a Lex bot resource with intents that include slots. The bot will be configured with a sample intent that requires user input for multiple slots. We will also set up the necessary IAM roles and policies to allow the Lex bot to function correctly. The configuration will include a provider for AWS in a specified region.

<iac_template>
```hcl
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
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "example_bot" {
  name        = "ExampleBot"
  description = "A sample Lex bot with multiple slots"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "OrderPizza"
    sample_utterances = [
      "I want to order a pizza",
      "Order a pizza"
    ]

    slot {
      name        = "PizzaType"
      slot_type   = "AMAZON.Food"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages {
          content_type = "PlainText"
          content      = "What type of pizza would you like?"
        }
        max_attempts = 3
      }
    }

    slot {
      name        = "PizzaSize"
      slot_type   = "AMAZON.Food"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages {
          content_type = "PlainText"
          content      = "What size of pizza would you like?"
        }
        max_attempts = 3
      }
    }
  }
}
```
</iac_template>

This Terraform configuration sets up an AWS Lex bot named "ExampleBot" with an intent called "OrderPizza" that includes two required slots: "PizzaType" and "PizzaSize". The bot is configured to use the "en-US" locale and is not child-directed. An IAM role and policy are created to allow the bot to log events to CloudWatch.