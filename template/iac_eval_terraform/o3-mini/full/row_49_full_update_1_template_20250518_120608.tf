This Terraform configuration deploys an AWS Lex bot geared for ordering pizzas. The configuration first creates a minimal Lex intent ("OrderPizzaIntent") which understands several sample utterances requesting a pizza order and returns a confirmation message once the intent has been fulfilled. Then it creates an AWS Lex bot ("ordering-pizza-bot") that includes that intent and is configured with an NLU intent confidence threshold of 0.5. The AWS provider is set to use the "us-east-1" region by default.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Create a Lex intent for ordering pizzas
resource "aws_lex_intent" "order_pizza_intent" {
  name               = "OrderPizzaIntent"
  description        = "Intent for ordering a pizza."
  
  sample_utterances = [
    "I want to order a pizza",
    "Order pizza",
    "Pizza order please"
  ]

  # When the intent is fulfilled, a conclusion statement message is returned.
  conclusion_statement {
    messages {
      content      = "Your pizza order has been received."
      content_type = "PlainText"
    }
  }

  # The fulfillment activity is set to simply return the intent.
  fulfillment_activity {
    type = "ReturnIntent"
  }
}

# Create a Lex bot that uses the above intent and has an NLU threshold of 0.5
resource "aws_lex_bot" "ordering_pizza_bot" {
  name                        = "ordering-pizza-bot"
  description                 = "Lex Bot for ordering pizzas."
  idle_session_ttl_in_seconds = 300
  voice_id                    = "Joanna"
  process_behavior            = "BUILD"
  locale                      = "en-US"
  child_directed              = false

  # Set the NLU intent confidence threshold as specified.
  nlu_intent_confidence_threshold = 0.5

  clarification_prompt {
    max_attempts = 2
    messages {
      content      = "I did not understand that. Could you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    messages {
      content      = "We are having some issues. Please try again later."
      content_type = "PlainText"
    }
  }

  # Include the OrderPizzaIntent created above.
  intents {
    intent_name    = aws_lex_intent.order_pizza_intent.name
    intent_version = aws_lex_intent.order_pizza_intent.version
  }
}
</iac_template>