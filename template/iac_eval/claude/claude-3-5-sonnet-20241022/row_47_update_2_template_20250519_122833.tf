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
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lexv2_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
    n_lu_intent_confidence_threshold = 0.40

    intent {
      name = "GreetingIntent"
      description = "Intent to handle customer greetings"
      
      sample_utterance {
        utterance = "Hello"
      }
      sample_utterance {
        utterance = "Hi there"
      }
      sample_utterance {
        utterance = "Good morning"
      }
    }

    intent {
      name = "OrderPizzaIntent"
      description = "Intent to handle pizza ordering"
      
      sample_utterance {
        utterance = "I want to order a pizza"
      }
      sample_utterance {
        utterance = "Can I get a pizza"
      }

      slot {
        name = "PizzaSize"
        description = "Size of the pizza"
        slot_constraint = "Required"
        value_elicitation_setting {
          setting {
            prompt_specification {
              message_groups {
                message {
                  plain_text_message {
                    value = "What size pizza would you like? (Small, Medium, or Large)"
                  }
                }
              }
              max_retries = 2
            }
          }
        }
        slot_type_name = "AMAZON.AlphaNumeric"
      }
    }

    intent {
      name = "CheckOrderStatusIntent"
      description = "Intent to check order status"
      
      sample_utterance {
        utterance = "Where is my order"
      }
      sample_utterance {
        utterance = "Check order status"
      }
    }

    intent {
      name = "CancelOrderIntent"
      description = "Intent to cancel orders"
      
      sample_utterance {
        utterance = "Cancel my order"
      }
      sample_utterance {
        utterance = "I want to cancel"
      }
    }

    intent {
      name = "GetPriceIntent"
      description = "Intent to get pizza prices"
      
      sample_utterance {
        utterance = "How much does it cost"
      }
      sample_utterance {
        utterance = "What are your prices"
      }
    }
  }
}

resource "aws_lexv2_bot_alias" "pizza_bot_alias" {
  bot_alias_name = "PizzaBotProduction"
  bot_id         = aws_lexv2_bot.pizza_bot.id
  bot_version    = "DRAFT"
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
          "lexv2:*"
        ]
        Resource = "*"
      }
    ]
  })
}