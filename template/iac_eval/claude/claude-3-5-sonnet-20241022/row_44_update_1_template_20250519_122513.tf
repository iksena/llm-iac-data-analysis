terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_pizza_bot_role"

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

# Create the Lex Bot
resource "aws_lexv2models_bot" "pizza_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizza"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
    nlu_confidence_threshold = 0.40
  }
}

# Create Bot Version
resource "aws_lexv2models_bot_version" "pizza_bot_version" {
  bot_id = aws_lexv2models_bot.pizza_bot.id
  description = "Pizza bot version 1"
}

# Create Bot Alias
resource "aws_lexv2models_bot_alias" "pizza_bot_alias" {
  bot_alias_name = "PizzaBotProduction"
  bot_id         = aws_lexv2models_bot.pizza_bot.id
  bot_version    = aws_lexv2models_bot_version.pizza_bot_version.bot_version
  description    = "Production alias for pizza ordering bot"
}

# Create Intent
resource "aws_lexv2models_intent" "order_pizza" {
  bot_id = aws_lexv2models_bot.pizza_bot.id
  bot_version = aws_lexv2models_bot_version.pizza_bot_version.bot_version
  locale_id   = "en_US"
  intent_name = "OrderPizza"
  description = "Intent for ordering pizza"

  sample_utterances {
    utterance = "I want to order a pizza"
  }

  sample_utterances {
    utterance = "Can I get a pizza"
  }

  sample_utterances {
    utterance = "Order pizza"
  }

  fulfillment_code_hook {
    enabled = false
  }

  slot {
    name        = "PizzaSize"
    description = "Size of the pizza"
    slot_constraint = "Required"
    value_elicitation_setting {
      setting_type = "Slot"
      slot_constraint = "Required"
      prompt_specification {
        message_groups {
          message {
            plain_text_message {
              value = "What size pizza would you like? (Small, Medium, or Large)"
            }
          }
        }
        max_retries = 2
        allow_interrupt = true
      }
    }
  }

  slot {
    name        = "PizzaToppings"
    description = "Toppings for the pizza"
    slot_constraint = "Required"
    value_elicitation_setting {
      setting_type = "Slot"
      slot_constraint = "Required"
      prompt_specification {
        message_groups {
          message {
            plain_text_message {
              value = "What toppings would you like on your pizza?"
            }
          }
        }
        max_retries = 2
        allow_interrupt = true
      }
    }
  }
}

# Create Slot Types
resource "aws_lexv2models_slot_type" "pizza_size" {
  slot_type_name = "PizzaSize"
  bot_id         = aws_lexv2models_bot.pizza_bot.id
  bot_version    = aws_lexv2models_bot_version.pizza_bot_version.bot_version
  locale_id      = "en_US"
  
  value_selection_setting {
    resolution_strategy = "TOP_RESOLUTION"
  }

  slot_type_value {
    sample_value {
      value = "Small"
    }
  }

  slot_type_value {
    sample_value {
      value = "Medium"
    }
  }

  slot_type_value {
    sample_value {
      value = "Large"
    }
  }
}

resource "aws_lexv2models_slot_type" "pizza_toppings" {
  slot_type_name = "PizzaToppings"
  bot_id         = aws_lexv2models_bot.pizza_bot.id
  bot_version    = aws_lexv2models_bot_version.pizza_bot_version.bot_version
  locale_id      = "en_US"
  
  value_selection_setting {
    resolution_strategy = "TOP_RESOLUTION"
  }

  slot_type_value {
    sample_value {
      value = "Pepperoni"
    }
  }

  slot_type_value {
    sample_value {
      value = "Mushrooms"
    }
  }

  slot_type_value {
    sample_value {
      value = "Cheese"
    }
  }
}