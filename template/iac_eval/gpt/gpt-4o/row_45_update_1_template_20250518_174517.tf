provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexBotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_bot_policy" {
  name   = "LexBotPolicy"
  role   = aws_iam_role.lex_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "polly:SynthesizeSpeech",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "pizza_ordering_bot" {
  name        = "PizzaOrderingBot"
  description = "A bot to order pizzas"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = aws_lex_intent.order_pizza_intent.name
    intent_version = aws_lex_intent.order_pizza_intent.version
  }

  clarification_prompt {
    max_attempts = 3
    messages {
      content_type = "PlainText"
      content      = "I didn't understand that. Can you please repeat?"
    }
  }

  abort_statement {
    messages {
      content_type = "PlainText"
      content      = "I'm sorry, I couldn't understand your request. Please try again later."
    }
  }
}

resource "aws_lex_intent" "order_pizza_intent" {
  name        = "OrderPizzaIntent"
  description = "Intent to order a pizza"

  slot {
    name        = "PizzaType"
    description = "Type of pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      max_attempts = 2
      messages {
        content_type = "PlainText"
        content      = "What type of pizza would you like?"
      }
    }
  }

  slot {
    name        = "PizzaSize"
    description = "Size of pizza"
    slot_constraint = "Required"
    slot_type = "AMAZON.Food"
    value_elicitation_prompt {
      max_attempts = 2
      messages {
        content_type = "PlainText"
        content      = "What size of pizza would you like?"
      }
    }
  }

  slot {
    name        = "Quantity"
    description = "Number of pizzas"
    slot_constraint = "Required"
    slot_type = "AMAZON.Number"
    value_elicitation_prompt {
      max_attempts = 2
      messages {
        content_type = "PlainText"
        content      = "How many pizzas would you like to order?"
      }
    }
  }

  conclusion_statement {
    messages {
      content_type = "PlainText"
      content      = "Thank you for your order. Your pizzas will be ready soon!"
    }
  }
}