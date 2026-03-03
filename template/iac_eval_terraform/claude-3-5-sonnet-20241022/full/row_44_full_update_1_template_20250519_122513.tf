I'll help you create a Terraform configuration for an AWS Lex bot that handles pizza orders with follow-up questions. The bot will be able to process pizza orders and ask follow-up questions about size, toppings, etc.

This configuration will:
1. Create an AWS Lex Bot V2
2. Define intents for ordering pizza
3. Set up slot types for pizza attributes
4. Configure follow-up prompts
5. Include necessary IAM roles and policies

Here's the complete Terraform configuration:

<iac_template>
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
</iac_template>

This Terraform configuration creates:
1. An AWS Lex V2 bot named "PizzaOrderingBot"
2. An IAM role for the bot
3. A bot version and alias
4. An intent for ordering pizza with two slots (size and toppings)
5. Slot types for pizza sizes and toppings
6. Follow-up prompts for gathering required information

The bot will:
- Recognize pizza ordering requests
- Ask for the pizza size (Small, Medium, or Large)
- Ask for desired toppings
- Support basic conversation flow for pizza ordering

To use this bot, you would need to:
1. Deploy the configuration
2. Test the bot in the AWS Console
3. Implement any backend fulfillment logic (not included in this configuration)

Note that this is a basic implementation and could be enhanced with more sophisticated dialogue management, additional intents, and more complex slot types.