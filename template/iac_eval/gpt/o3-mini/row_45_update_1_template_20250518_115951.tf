provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}

# Custom slot type for Pizza Types
resource "aws_lex_slot_type" "pizza_type" {
  name        = "PizzaTypeSlot"
  description = "Custom slot type for pizza types"

  enumeration_value {
    value = "Margherita"
  }

  enumeration_value {
    value = "Pepperoni"
  }

  enumeration_value {
    value = "Veggie"
  }

  enumeration_value {
    value = "BBQ Chicken"
  }

  enumeration_value {
    value = "Hawaiian"
  }
}

# Custom slot type for Pizza Sizes
resource "aws_lex_slot_type" "pizza_size" {
  name        = "PizzaSizeSlot"
  description = "Custom slot type for pizza sizes"

  enumeration_value {
    value = "Small"
  }

  enumeration_value {
    value = "Medium"
  }

  enumeration_value {
    value = "Large"
  }
}

# Lex Intent for ordering pizzas
resource "aws_lex_intent" "order_pizza" {
  name        = "OrderPizza"
  description = "Intent to order pizzas."

  sample_utterances = [
    "I want to order a pizza",
    "Order a pizza for me",
    "Pizza order"
  ]

  # Define a slot for the pizza type
  slot {
    name                = "PizzaType"
    slot_constraint     = "Required"
    slot_type           = aws_lex_slot_type.pizza_type.name
    slot_type_version   = "$LATEST"
    prompt              = "What type of pizza would you like? (e.g., Margherita, Pepperoni)"
    priority            = 1
    sample_utterances   = [
      "I want a {PizzaType} pizza",
      "Get me a {PizzaType} pizza"
    ]
  }

  # Define a slot for the pizza size
  slot {
    name                = "PizzaSize"
    slot_constraint     = "Required"
    slot_type           = aws_lex_slot_type.pizza_size.name
    slot_type_version   = "$LATEST"
    prompt              = "What size would you like? (Small, Medium, or Large)"
    priority            = 2
    sample_utterances   = [
      "Make it {PizzaSize}",
      "I need a {PizzaSize} pizza"
    ]
  }

  # Conclusion statement delivered when the intent is fulfilled
  conclusion_statement {
    message {
      content      = "Your pizza order has been successfully placed! Enjoy your meal."
      content_type = "PlainText"
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Bot that uses the OrderPizza intent
resource "aws_lex_bot" "pizza_bot" {
  name                 = "PizzaOrderingBot"
  description          = "Lex Bot for ordering pizzas with a conclusion statement."
  child_directed       = false

  # The bot references the OrderPizza intent we created.
  intent {
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = "$LATEST"
  }

  clarification_prompt {
    max_attempts = 2

    message {
      content      = "I'm sorry, I didn't understand that. Could you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "I'm sorry, I couldn't understand you. Please try again later."
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  voice_id                    = "Joanna"
  process_behavior            = "BUILD"
}