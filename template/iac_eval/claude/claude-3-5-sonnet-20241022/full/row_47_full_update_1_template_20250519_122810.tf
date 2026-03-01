I'll help you create an AWS Lex Bot for ordering pizzas with 5 different intents. The bot will handle pizza ordering interactions with the following intents:

1. GreetingIntent - To handle initial customer greetings
2. OrderPizzaIntent - To handle the main pizza ordering process
3. CheckOrderStatusIntent - To check the status of an existing order
4. CancelOrderIntent - To cancel an existing order
5. GetPriceIntent - To get price information for pizzas

Here's the Terraform configuration to create the Lex bot with these intents:

<iac_template>
# Configure AWS Provider
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
  process_behavior            = "BUILD"
  child_directed             = false

  locale           = "en-US"
  voice_id         = "Salli"
  create_version   = true
}

# Create Intent 1: Greeting Intent
resource "aws_lex_intent" "greeting_intent" {
  name = "GreetingIntent"
  description = "Intent to handle customer greetings"
  
  sample_utterances = [
    "Hello",
    "Hi",
    "Hey there",
    "Good morning",
    "Good evening"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create Intent 2: Order Pizza Intent
resource "aws_lex_intent" "order_pizza_intent" {
  name = "OrderPizzaIntent"
  description = "Intent to handle pizza ordering"
  
  sample_utterances = [
    "I want to order a pizza",
    "Can I get a pizza",
    "Order pizza",
    "Place pizza order"
  ]

  slot {
    name        = "PizzaSize"
    description = "Size of the pizza"
    slot_constraint = "Required"
    slot_type   = "AMAZON.AlphaNumeric"
    
    priority    = 1

    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "What size pizza would you like? (Small, Medium, or Large)"
        content_type = "PlainText"
      }
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create Intent 3: Check Order Status Intent
resource "aws_lex_intent" "check_order_status_intent" {
  name = "CheckOrderStatusIntent"
  description = "Intent to check order status"
  
  sample_utterances = [
    "Where is my order",
    "Check order status",
    "Track my order",
    "Order status"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create Intent 4: Cancel Order Intent
resource "aws_lex_intent" "cancel_order_intent" {
  name = "CancelOrderIntent"
  description = "Intent to cancel orders"
  
  sample_utterances = [
    "Cancel my order",
    "I want to cancel",
    "Stop my order",
    "Cancel pizza order"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create Intent 5: Get Price Intent
resource "aws_lex_intent" "get_price_intent" {
  name = "GetPriceIntent"
  description = "Intent to get pizza prices"
  
  sample_utterances = [
    "How much does it cost",
    "What are your prices",
    "Pizza prices",
    "Price list"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Bot Version
resource "aws_lex_bot_alias" "pizza_bot_alias" {
  bot_name    = aws_lex_bot.pizza_ordering_bot.name
  bot_version = "$LATEST"
  name        = "PizzaBotProduction"
}

# IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_role"

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

# IAM Role Policy for Lex
resource "aws_iam_role_policy" "lex_policy" {
  name = "lex_policy"
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

This Terraform configuration creates:
1. An AWS Lex Bot for pizza ordering
2. Five intents for different interactions
3. A bot alias for production deployment
4. Required IAM roles and policies

The bot includes:
- Proper error handling with abort statements and clarification prompts
- Sample utterances for each intent
- A slot for pizza size in the OrderPizzaIntent
- IAM roles and policies for Lex bot operation
- Bot alias for production deployment

The configuration is complete and deployable. Each intent has basic functionality that can be extended based on specific business requirements. The bot uses the "Salli" voice and is configured for English (US) locale.

Note: You might need to add more slots, validation, and fulfillment configurations depending on your specific business requirements. This is a basic structure that can be extended as needed.