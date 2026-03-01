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
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "pizza_ordering_bot" {
  name        = "PizzaOrderingBot"
  description = "A bot to order pizzas with various options"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "ChoosePizzaType"
    intent_version = "$LATEST"
  }

  intent {
    intent_name = "SelectPizzaSize"
    intent_version = "$LATEST"
  }

  intent {
    intent_name = "AddToppings"
    intent_version = "$LATEST"
  }

  intent {
    intent_name = "ConfirmOrder"
    intent_version = "$LATEST"
  }

  intent {
    intent_name = "CancelOrder"
    intent_version = "$LATEST"
  }

  voice_id = "Joanna"
  process_behavior = "BUILD"
}

resource "aws_lex_intent" "choose_pizza_type" {
  name        = "ChoosePizzaType"
  description = "Intent to choose the type of pizza"
  sample_utterances = [
    "I want a {PizzaType} pizza",
    "Can I have a {PizzaType} pizza",
    "Order a {PizzaType} pizza"
  ]

  slot {
    name        = "PizzaType"
    slot_type   = "AMAZON.Food"
    slot_constraint = "Required"
    value_elicitation_prompt {
      messages = [
        {
          content_type = "PlainText"
          content      = "What type of pizza would you like?"
        }
      ]
      max_attempts = 3
    }
  }
}

resource "aws_lex_intent" "select_pizza_size" {
  name        = "SelectPizzaSize"
  description = "Intent to select the size of the pizza"
  sample_utterances = [
    "I want a {PizzaSize} pizza",
    "Make it a {PizzaSize} pizza",
    "I'd like a {PizzaSize} size"
  ]

  slot {
    name        = "PizzaSize"
    slot_type   = "AMAZON.Food"
    slot_constraint = "Required"
    value_elicitation_prompt {
      messages = [
        {
          content_type = "PlainText"
          content      = "What size of pizza would you like?"
        }
      ]
      max_attempts = 3
    }
  }
}

resource "aws_lex_intent" "add_toppings" {
  name        = "AddToppings"
  description = "Intent to add toppings to the pizza"
  sample_utterances = [
    "Add {Topping} to my pizza",
    "I want {Topping} on my pizza",
    "Include {Topping} as a topping"
  ]

  slot {
    name        = "Topping"
    slot_type   = "AMAZON.Food"
    slot_constraint = "Optional"
    value_elicitation_prompt {
      messages = [
        {
          content_type = "PlainText"
          content      = "What toppings would you like to add?"
        }
      ]
      max_attempts = 3
    }
  }
}

resource "aws_lex_intent" "confirm_order" {
  name        = "ConfirmOrder"
  description = "Intent to confirm the pizza order"
  sample_utterances = [
    "Confirm my order",
    "Yes, place the order",
    "Go ahead with the order"
  ]
}

resource "aws_lex_intent" "cancel_order" {
  name        = "CancelOrder"
  description = "Intent to cancel the pizza order"
  sample_utterances = [
    "Cancel my order",
    "I want to cancel the order",
    "Forget the order"
  ]
}