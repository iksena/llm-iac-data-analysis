Below is a description of the Terraform program that will be defined and deployed:

Description:
• The configuration sets up an AWS provider with the region "us-east-1".
• Five AWS Lex intents are created to cover different parts of the ordering pizzas conversation process. The intents are: OrderPizza, CheckOrderStatus, CancelOrder, ModifyOrder, and HelpIntent. Each intent is defined with a simple description, some sample utterances, and a fulfillment activity configured as a "ReturnIntent" (meaning Lex will simply return the input).
• An AWS Lex bot (PizzaBot) is then defined that includes the five intents, using the "$LATEST" intent version. In addition, the bot defines a clarification prompt and an abort statement as required by AWS Lex.
• The configuration is self-contained with all required resources, variables (with default values), provider configuration, and IAM roles (if necessary in a more complete deployment). In this case, Lex does not require custom IAM roles in this sample, but the provider configuration is complete.
• The entire code is wrapped within <iac_template></iac_template> tags.

Below is the complete Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Lex Intent for ordering a pizza
resource "aws_lex_intent" "order_pizza" {
  name               = "OrderPizza"
  description        = "Intent to order a pizza"
  sample_utterances  = [
    "I want to order a pizza",
    "Order me a pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for checking order status
resource "aws_lex_intent" "check_order_status" {
  name               = "CheckOrderStatus"
  description        = "Intent to check the status of a pizza order"
  sample_utterances  = [
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
  name               = "CancelOrder"
  description        = "Intent to cancel a pizza order"
  sample_utterances  = [
    "Cancel my order",
    "I want to cancel my pizza order"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Lex Intent for modifying an order
resource "aws_lex_intent" "modify_order" {
  name               = "ModifyOrder"
  description        = "Intent to modify a pizza order"
  sample_utterances  = [
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
  name               = "HelpIntent"
  description        = "Intent to ask for help about ordering pizzas"
  sample_utterances  = [
    "I need help",
    "What can you do?",
    "Help me with ordering pizza"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Define the Lex Bot that uses the 5 intents above
resource "aws_lex_bot" "pizza_bot" {
  name              = "PizzaBot"
  description       = "A bot for ordering pizzas using Lex"
  locale            = "en-US"
  child_directed    = false
  idle_session_ttl  = 5
  voice_id          = "Joanna"

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

  # Include the intents in the bot using $LATEST version placeholder
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