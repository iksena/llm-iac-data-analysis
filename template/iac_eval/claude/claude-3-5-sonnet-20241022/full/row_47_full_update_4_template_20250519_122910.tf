I'll provide a corrected version using the proper `aws_lex_bot` resource type instead of `aws_lexv2_bot`.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_role" {
  name = "lex_bot_role"

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

resource "aws_lex_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  idle_session_ttl_in_seconds = 300
  child_directed = false
  voice_id = "Salli"
  process_behavior = "BUILD"
  
  abort_statement {
    message {
      content = "Sorry, I cannot help you at this time. Please try again later."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content = "I didn't understand you. Could you please rephrase that?"
      content_type = "PlainText"
    }
  }
}

resource "aws_lex_intent" "greeting_intent" {
  name = "GreetingIntent"
  description = "Intent to handle customer greetings"
  
  sample_utterances = [
    "Hello",
    "Hi there",
    "Good morning"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_intent" "order_pizza_intent" {
  name = "OrderPizzaIntent"
  description = "Intent to handle pizza ordering"
  
  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }

  slot {
    name = "PizzaSize"
    description = "Size of the pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.AlphaNumeric"
    priority = 1

    value_elicitation_prompt {
      max_attempts = 2
      message {
        content = "What size pizza would you like? (Small, Medium, or Large)"
        content_type = "PlainText"
      }
    }
  }
}

resource "aws_lex_intent" "check_status_intent" {
  name = "CheckOrderStatusIntent"
  description = "Intent to check order status"
  
  sample_utterances = [
    "Where is my order",
    "Check order status"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_intent" "cancel_order_intent" {
  name = "CancelOrderIntent"
  description = "Intent to cancel orders"
  
  sample_utterances = [
    "Cancel my order",
    "I want to cancel"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_intent" "get_price_intent" {
  name = "GetPriceIntent"
  description = "Intent to get pizza prices"
  
  sample_utterances = [
    "How much does it cost",
    "What are your prices"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_bot_alias" "pizza_bot_alias" {
  bot_name = aws_lex_bot.pizza_bot.name
  bot_version = "$LATEST"
  name = "PizzaBotProduction"
}

resource "aws_iam_role_policy" "lex_policy" {
  name = "lex_bot_policy"
  role = aws_iam_role.lex_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lex:*"
        ]
        Resource = "*"
      }
    ]
  })
}
</iac_template>

This corrected version:
1. Uses the correct resource type `aws_lex_bot` instead of `aws_lexv2_bot`
2. Uses the correct service name in the IAM role (`lex.amazonaws.com`)
3. Includes all required fields for the Lex bot configuration
4. Properly structures the intents with their required fields
5. Uses the correct bot alias configuration

The template now creates:
- An IAM role for the Lex bot
- A Lex bot for pizza ordering
- 5 different intents (Greeting, Order Pizza, Check Status, Cancel Order, and Get Price)
- A bot alias for production deployment
- The necessary IAM policies

Each intent has its own sample utterances and fulfillment activity, and the Order Pizza intent includes a slot for pizza size selection.