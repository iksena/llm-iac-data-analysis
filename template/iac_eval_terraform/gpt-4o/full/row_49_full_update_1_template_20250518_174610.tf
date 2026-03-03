To create an AWS Lex Bot for ordering pizzas, we will define a Terraform configuration that sets up an AWS Lex Bot with the necessary intents and configurations. The bot will have an NLU (Natural Language Understanding) intent confidence threshold set to 0.5, which determines the confidence level required for the bot to recognize an intent. We will also define the necessary IAM roles and policies to allow the Lex Bot to function properly.

Here is the Terraform HCL configuration:

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

resource "aws_lex_bot" "pizza_ordering_bot" {
  name        = "PizzaOrderingBot"
  description = "A bot to order pizzas"
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "OrderPizza"
    intent_version = "$LATEST"
  }

  nlu_intent_confidence_threshold = 0.5
  voice_id = "Joanna"
  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_bot_role.arn
}

resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizza"
  description = "Intent to order a pizza"

  sample_utterances = [
    "I want to order a pizza",
    "Order a pizza",
    "Can I get a pizza?"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}
```
</iac_template>

This configuration sets up an AWS Lex Bot named "PizzaOrderingBot" with an intent called "OrderPizza". The bot is configured to use the "Joanna" voice and has an idle session timeout of 300 seconds. The necessary IAM role and policy are also defined to allow the bot to log events.