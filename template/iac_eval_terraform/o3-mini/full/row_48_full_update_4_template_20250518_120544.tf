<iac_template>
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Lex Intent for ordering pizzas
resource "aws_lex_intent" "order_pizza" {
  name        = "OrderPizza"
  description = "Intent to order a pizza for kids"

  sample_utterances = [
    "I want a pizza",
    "Pizza please",
    "Can I have a pizza?"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }

  conclusion_statement {
    message {
      content      = "Thank you for ordering your pizza! Enjoy your meal!"
      content_type = "PlainText"
    }
  }
}

# Lex Bot configured for kids ordering pizzas
resource "aws_lex_bot" "pizza_bot" {
  name                        = "PizzaForKidsBot"
  description                 = "A Lex bot designed for kids to order their favorite pizzas"
  locale                      = "en-US"
  child_directed              = true
  process_behavior            = "BUILD"
  idle_session_ttl_in_seconds = 300

  intents {
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = "$LATEST"
  }

  clarification_prompt {
    message {
      content      = "I did not understand that. Can you please repeat?"
      content_type = "PlainText"
    }
    max_attempts = 2
  }

  abort_statement {
    message {
      content      = "I am sorry, but I am not able to assist with that."
      content_type = "PlainText"
    }
  }
}
</iac_template>