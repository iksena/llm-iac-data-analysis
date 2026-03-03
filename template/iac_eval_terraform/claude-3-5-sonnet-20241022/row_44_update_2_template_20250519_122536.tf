terraform {
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

# IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_pizza_bot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

# Basic Lex Bot
resource "aws_lex_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizza"
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding. Please try again."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you, what would you like to order?"
      content_type = "PlainText"
    }
  }

  child_directed = false
  
  locale = "en-US"
  
  process_behavior = "BUILD"
  voice_id = "Salli"

  intent {
    intent_name    = "OrderPizza"
    intent_version = "1"
  }
}

# Intent
resource "aws_lex_intent" "order_pizza" {
  name = "OrderPizza"
  
  fulfillment_activity {
    type = "ReturnIntent"
  }

  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza",
    "Order pizza"
  ]

  slot {
    name        = "PizzaSize"
    description = "Size of the pizza"
    priority    = 1
    slot_type   = "PizzaSize"
    slot_constraint = "Required"
    
    slot_prompt {
      max_attempts = 2
      message {
        content      = "What size pizza would you like? (Small, Medium, or Large)"
        content_type = "PlainText"
      }
    }
  }

  slot {
    name        = "PizzaToppings"
    description = "Toppings for the pizza"
    priority    = 2
    slot_type   = "PizzaToppings"
    slot_constraint = "Required"
    
    slot_prompt {
      max_attempts = 2
      message {
        content      = "What toppings would you like on your pizza?"
        content_type = "PlainText"
      }
    }
  }
}

# Slot Types
resource "aws_lex_slot_type" "pizza_size" {
  name = "PizzaSize"
  
  enumeration_values {
    value = "Small"
  }
  
  enumeration_values {
    value = "Medium"
  }
  
  enumeration_values {
    value = "Large"
  }
}

resource "aws_lex_slot_type" "pizza_toppings" {
  name = "PizzaToppings"
  
  enumeration_values {
    value = "Pepperoni"
  }
  
  enumeration_values {
    value = "Mushrooms"
  }
  
  enumeration_values {
    value = "Cheese"
  }
}