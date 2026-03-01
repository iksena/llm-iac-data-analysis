terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region where resources are deployed."
  type        = string
  default     = "us-east-1"
}

# AWS Lex Intent with two slots: PizzaSize and PizzaType.
resource "aws_lex_intent" "order_pizza_intent" {
  name              = "OrderPizzaIntent"
  description       = "Intent to order a pizza with multiple slots."
  sample_utterances = [
    "I want to order a pizza",
    "Order a pizza"
  ]

  # Slot for pizza size.
  slot {
    name            = "PizzaSize"
    description     = "Size of the pizza to order"
    slot_constraint = "Required"
    slot_type       = "AMAZON.Food"

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content      = "What size pizza would you like?"
        content_type = "PlainText"
      }
    }
  }

  # Slot for pizza type.
  slot {
    name            = "PizzaType"
    description     = "Type of pizza to order"
    slot_constraint = "Required"
    slot_type       = "AMAZON.Food"

    value_elicitation_prompt {
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

# AWS Lex Bot referencing the above intent.
resource "aws_lex_bot" "order_pizza_bot" {
  name                        = "OrderPizzaBot"
  description                 = "Bot to handle pizza orders with multiple slots."
  locale                      = "en-US"
  voice_id                    = "Joanna"
  process_behavior            = "BUILD"
  child_directed              = false
  idle_session_ttl_in_seconds = 300

  intents {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = "$LATEST"
  }

  clarification_prompt {
    max_attempts = 2

    message {
      content      = "Sorry, can you please repeat that?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "I'm stopping the conversation now."
      content_type = "PlainText"
    }
  }
}