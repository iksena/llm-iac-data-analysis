Below is an improved version of the Terraform configuration. In this revised version, we have ensured that all required blocks are correctly nested and that resource attributes follow the proper Terraform syntax. We include the AWS provider configuration, define the five Lex intents, and then create the Lex bot that references them. Note that AWS Lex resources can be sensitive to JSON formatting and naming conventions. Make sure the AWS provider version you are using supports these resources. Here is the complete, deployable template:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Lex Intent for ordering a pizza
resource "aws_lex_intent" "order_pizza" {
  name              = "OrderPizza"
  description       = "Intent to order a pizza"
  sample_utterances = [
    "I want to order a pizza",
    "Order me a pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for checking order status
resource "aws_lex_intent" "check_order_status" {
  name              = "CheckOrderStatus"
  description       = "Intent to check the status of a pizza order"
  sample_utterances = [
    "What is the status of my order?",
    "Track my pizza order",
    "Check order status"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for canceling an order
resource "aws_lex_intent" "cancel_order" {
  name              = "CancelOrder"
  description       = "Intent to cancel a pizza order"
  sample_utterances = [
    "Cancel my order",
    "I want to cancel my pizza order"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for modifying an order
resource "aws_lex_intent" "modify_order" {
  name              = "ModifyOrder"
  description       = "Intent to modify a pizza order"
  sample_utterances = [
    "I want to change my order",
    "Modify my pizza order",
    "Change my pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for help
resource "aws_lex_intent" "help_intent" {
  name              = "HelpIntent"
  description       = "Intent to ask for help about ordering pizzas"
  sample_utterances = [
    "I need help",
    "What can you do?",
    "Help me with ordering pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Define the Lex Bot with the five intents
resource "aws_lex_bot" "pizza_bot" {
  name             = "PizzaBot"
  description      = "A bot for ordering pizzas using Lex"
  locale           = "en-US"
  child_directed   = false
  idle_session_ttl = 5
  voice_id         = "Joanna"

  clarification_prompt {
    max_attempts = 2

    message {
      content      = "I'm sorry, can you please repeat that?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "Sorry, I could not understand. Goodbye."
      content_type = "PlainText"
    }
  }

  # Enter the intents with $LATEST version for each
  intent {
    intent_name    = aws_lex_intent.order_pizza.name
    intent_version = "$LATEST"
  }
  intent {
    intent_name    = aws_lex_intent.check_order_status.name
    intent_version = "$LATEST"
  }
  intent {
    intent_name    = aws_lex_intent.cancel_order.name
    intent_version = "$LATEST"
  }
  intent {
    intent_name    = aws_lex_intent.modify_order.name
    intent_version = "$LATEST"
  }
  intent {
    intent_name    = aws_lex_intent.help_intent.name
    intent_version = "$LATEST"
  }
}
</iac_template>

This improved template should deploy successfully, assuming that your provider version supports these Lex resources.