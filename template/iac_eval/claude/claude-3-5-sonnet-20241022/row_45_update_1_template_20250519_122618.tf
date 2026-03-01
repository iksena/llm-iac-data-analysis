provider "aws" {
  region = "us-east-1"
}

# Create the Lex Bot
resource "aws_lex_bot" "pizza_ordering_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding you. Could you try again?"
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you. Could you please rephrase that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  
  intent {
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = aws_lex_intent.order_pizza.version
  }

  child_directed = false
  
  process_behavior = "BUILD"
  voice_id        = "Salli"
  
  conclusion_statement {
    message {
      content = "Great! Your pizza order has been placed. Your pizza will be ready in 30 minutes. Thank you for ordering with us!"
      content_type = "PlainText"
    }
  }
}

# Create Intent for Pizza Ordering
resource "aws_lex_intent" "order_pizza" {
  name = "OrderPizza"
  description = "Intent for ordering pizzas"
  
  fulfillment_activity {
    type = "ReturnIntent"
  }

  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza",
    "I would like to order a pizza",
    "Pizza order"
  ]

  slot {
    name        = "PizzaSize"
    description = "Size of the pizza"
    priority    = 1

    slot_constraint = "Required"
    slot_type      = "AMAZON.AlphaNumeric"

    sample_utterances = [
      "I want a {PizzaSize} pizza"
    ]

    prompt {
      max_attempts = 2
      message {
        content      = "What size pizza would you like? (Small, Medium, or Large)"
        content_type = "PlainText"
      }
    }
  }

  slot {
    name        = "PizzaType"
    description = "Type of pizza"
    priority    = 2

    slot_constraint = "Required"
    slot_type      = "AMAZON.AlphaNumeric"

    sample_utterances = [
      "I want a {PizzaType} pizza"
    ]

    prompt {
      max_attempts = 2
      message {
        content      = "What type of pizza would you like? (Pepperoni, Margherita, or Vegetarian)"
        content_type = "PlainText"
      }
    }
  }
}