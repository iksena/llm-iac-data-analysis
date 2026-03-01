provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_bot_role" {
  name = "kids_pizza_bot_role"

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
  name = "KidsPizzaBot"
  description = "A kid-friendly pizza ordering bot"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_bot_role.arn

  data_privacy {
    child_directed = true
  }

  bot_locale {
    locale_id = "en_US"
    
    intent {
      name = "OrderPizza"
      description = "Intent to handle pizza orders"
      
      sample_utterances {
        utterance = "I want a pizza"
      }
      sample_utterances {
        utterance = "Can I have a pizza please"
      }
      sample_utterances {
        utterance = "Pizza time"
      }

      slot {
        name = "PizzaSize"
        description = "Size of the pizza"
        slot_constraint = "Required"
        slot_type_name = "PizzaSize"
        value_elicitation_setting {
          setting {
            prompt_specification {
              message_groups {
                message {
                  plain_text_message {
                    value = "What size pizza would you like? Small, Medium, or Large?"
                  }
                }
              }
              max_retries = 2
            }
          }
        }
      }

      slot {
        name = "PizzaTopping"
        description = "Topping for the pizza"
        slot_constraint = "Required"
        slot_type_name = "PizzaTopping"
        value_elicitation_setting {
          setting {
            prompt_specification {
              message_groups {
                message {
                  plain_text_message {
                    value = "What topping would you like? We have cheese, pepperoni, or mushroom!"
                  }
                }
              }
              max_retries = 2
            }
          }
        }
      }
    }

    slot_type {
      name = "PizzaSize"
      description = "Size options for pizza"
      value_selection_setting {
        resolution_strategy = "ORIGINAL_VALUE"
      }
      slot_type_values {
        sample_value {
          value = "Small"
        }
      }
      slot_type_values {
        sample_value {
          value = "Medium"
        }
      }
      slot_type_values {
        sample_value {
          value = "Large"
        }
      }
    }

    slot_type {
      name = "PizzaTopping"
      description = "Available pizza toppings"
      value_selection_setting {
        resolution_strategy = "ORIGINAL_VALUE"
      }
      slot_type_values {
        sample_value {
          value = "Cheese"
        }
      }
      slot_type_values {
        sample_value {
          value = "Pepperoni"
        }
      }
      slot_type_values {
        sample_value {
          value = "Mushroom"
        }
      }
    }
  }
}

# Create a bot version
resource "aws_lexv2models_bot_version" "pizza_bot_version" {
  bot_id = aws_lexv2models_bot.pizza_bot.id
  description = "Initial version of kids pizza bot"
}

# Create a bot alias
resource "aws_lexv2models_bot_alias" "pizza_bot_alias" {
  bot_alias_name = "PizzaBotProduction"
  bot_id         = aws_lexv2models_bot.pizza_bot.id
  bot_version    = aws_lexv2models_bot_version.pizza_bot_version.bot_version
  description    = "Production alias for kids pizza bot"
}