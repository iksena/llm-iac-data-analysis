To create an AWS Lex Bot for ordering pizzas that is designed for kids, we will define a Terraform configuration that sets up an AWS Lex Bot with a simple interaction model. The bot will have intents related to ordering pizzas, such as choosing a pizza type and size. We will also define a basic IAM role that allows the Lex Bot to interact with AWS services. The bot will be deployed in the `us-east-1` region.

The configuration will include:
- An AWS provider configuration.
- An IAM role for the Lex Bot with necessary permissions.
- An AWS Lex Bot with intents and sample utterances suitable for kids.

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
          "polly:SynthesizeSpeech",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "pizza_ordering_bot" {
  name        = "KidsPizzaOrderingBot"
  description = "A bot for kids to order pizzas"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = true

  intent {
    intent_name = "OrderPizza"
    intent_version = "$LATEST"
  }

  voice_id = "Joanna"
}

resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizza"
  description = "Intent to order a pizza"
  sample_utterances = [
    "I want a pizza",
    "Can I order a pizza?",
    "Pizza please",
    "I would like a pizza"
  ]

  slot {
    name        = "PizzaType"
    description = "Type of pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      messages = [
        {
          content_type = "PlainText"
          content      = "What type of pizza would you like?"
        }
      ]
      max_attempts = 2
    }
  }

  slot {
    name        = "PizzaSize"
    description = "Size of the pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      messages = [
        {
          content_type = "PlainText"
          content      = "What size do you want? Small, medium, or large?"
        }
      ]
      max_attempts = 2
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}
```
</iac_template>