terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy the Lex Bot"
  type        = string
  default     = "us-east-1"
}

resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizza"
  description = "Intent for ordering pizza with a followup confirmation question"

  sample_utterances = [
    "I want to order a pizza",
    "Order me a pizza",
    "Pizza please"
  ]

  confirmation_prompt {
    max_attempts = 2

    message {
      content      = "Would you like to add extra toppings?"
      content_type = "PlainText"
    }
  }

  slot {
    name      = "PizzaType"
    slot_type = "AMAZON.Food"

    prompt {
      max_attempts = 2

      message {
        content      = "What type of pizza would you like?"
        content_type = "PlainText"
      }
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_bot" "order_pizza_bot" {
  name                        = "OrderPizzaBot"
  description                 = "Bot to order pizzas with a followup confirmation question"
  locale                      = "en-US"
  child_directed              = false
  idle_session_ttl_in_seconds = 300
  process_behavior            = "BUILD"

  intent {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = "$LATEST"
  }
}