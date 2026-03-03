I'll create a simpler version of the Lex bot that follows the correct syntax:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create IAM Role for Lex
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

# Attach basic Lex permissions to the role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexRunBotsPolicy"
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

    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "What size pizza would you like? (Small, Medium, or Large)"
        content_type = "PlainText"
      }
    }
  }
}

# Create the Lex Bot
resource "aws_lex_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "A bot for ordering pizzas"
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding you. Please try again later."
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

  intent {
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = "$LATEST"
  }

  child_directed = false
  
  process_behavior = "BUILD"
  voice_id        = "Salli"

  idle_session_ttl_in_seconds = 300

  depends_on = [aws_iam_role.lex_role, aws_lex_intent.order_pizza]
}
</iac_template>

This template creates:
1. An IAM role for Lex bot
2. A Lex intent for ordering pizza with a slot for pizza size
3. A Lex bot that uses the intent
4. Necessary permissions and configurations

The main changes from the previous version:
- Removed the unsupported `conclusion_statement` block
- Kept the core functionality intact
- Maintained proper syntax for the Lex bot and intent resources

Note that this bot will handle basic pizza ordering functionality. The bot will ask for the pizza size when a user initiates a pizza order conversation.