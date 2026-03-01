terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Define an AWS Lex Intent with multiple slots for ordering pizza.
resource "aws_lex_intent" "order_pizza_intent" {
  name               = "OrderPizzaIntent"
  description        = "Intent to order pizza with multiple slots."
  sample_utterances  = [
    "I want to order a pizza",
    "Order a pizza"
  ]

  # First slot: PizzaSize
  slot {
    name            = "PizzaSize"
    description     = "Size of pizza to order."
    slot_constraint = "Required"
    slot_type       = "AMAZON.Food"

    value_elicitation_prompt {
      max_attempts = 2
      messages {
        content      = "What size pizza would you like?"
        content_type = "PlainText"
      }
    }
  }

  # Second slot: PizzaType
  slot {
    name            = "PizzaType"
    description     = "Type of pizza to order."
    slot_constraint = "Required"
    slot_type       = "AMAZON.Food"

    value_elicitation_prompt {
      max_attempts = 2
      messages {
        content      = "What type of pizza would you like?"
        content_type = "PlainText"
      }
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Define an AWS Lex Bot that references the intent defined above.
resource "aws_lex_bot" "order_pizza_bot" {
  name                              = "OrderPizzaBot"
  description                       = "Bot to handle pizza orders with multiple slots."
  locale                            = "en-US"
  voice_id                          = "Joanna"
  process_behavior                  = "BUILD"
  child_directed                    = false
  idle_session_ttl_in_seconds       = 300

  intents {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = "$LATEST"
  }

  clarification_prompt {
    max_attempts = 2
    messages {
      content      = "Sorry, can you please repeat that?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    messages {
      content      = "I'm stopping the conversation now."
      content_type = "PlainText"
    }
  }
}