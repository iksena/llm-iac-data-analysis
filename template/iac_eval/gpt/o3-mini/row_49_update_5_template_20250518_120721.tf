provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

# Create a Lex intent for ordering pizzas
resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizzaIntent"
  description = "Intent for ordering a pizza."

  sample_utterances = [
    "I want to order a pizza",
    "Order pizza",
    "Pizza order please"
  ]

  conclusion_statement {
    message {
      content      = "Your pizza order has been received."
      content_type = "PlainText"
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create a Lex bot that uses the above intent and sets the NLU confidence threshold to 0.5
resource "aws_lex_bot" "ordering_pizza_bot" {
  name                        = "ordering-pizza-bot"
  description                 = "Lex Bot for ordering pizzas."
  idle_session_ttl_in_seconds = 300
  voice_id                    = "Joanna"
  process_behavior            = "BUILD"
  locale                      = "en-US"
  child_directed              = false

  nlu_intent_confidence_threshold = 0.5

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I did not understand that. Could you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "We are having some issues. Please try again later."
      content_type = "PlainText"
    }
  }

  intent {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = aws_lex_intent.order_pizza_intent.version
  }
}