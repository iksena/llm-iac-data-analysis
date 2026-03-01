Below is an overview of the Terraform program followed by the complete Terraform HCL configuration. In this example we create an AWS Lex intent (“OrderPizza”) that defines sample utterances for ordering a pizza, includes a slot (PizzaType) with a prompt asking what type of pizza the user wants, and sets a confirmation prompt as a followup question (“Would you like extra toppings?”). This intent is then attached to an AWS Lex bot (“OrderPizzaBot”) which is built in the US East (N. Virginia) region. The program also includes an AWS provider configuration so that the deployment is complete and deployable.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_lex_intent" "order_pizza_intent" {
  name               = "OrderPizza"
  description        = "Intent for ordering pizza with a followup confirmation question"
  sample_utterances  = [
    "I want to order a pizza",
    "Order me a pizza",
    "Pizza please"
  ]

  # The confirmation prompt acts as a follow-up question to ask about extra toppings.
  confirmation_prompt {
    max_attempts = 2

    message {
      content      = "Would you like to add extra toppings?"
      content_type = "PlainText"
    }
  }

  # Define a slot for the type of pizza.
  slot {
    name      = "PizzaType"
    slot_type = "AMAZON.Food" 

    prompt {
      max_attempts = 2

      message {
        content      = "What type of pizza would you like?"
        content_type = "PlainText"
      }
    }
  }

  # For this sample fulfillment, we simply return the intent.
  fulfillment_activity {
    type = "ReturnIntent"
  }
}

resource "aws_lex_bot" "order_pizza_bot" {
  name                    = "OrderPizzaBot"
  description             = "Bot to order pizzas with a followup confirmation question"
  locale                  = "en-US"
  child_directed          = false
  idle_session_ttl_in_seconds = 300
  process_behavior        = "BUILD"

  intent {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = aws_lex_intent.order_pizza_intent.version
  }
}
</iac_template>