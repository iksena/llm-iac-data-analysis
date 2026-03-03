I'll help you create a Terraform configuration for an AWS Lex Bot designed for pizza ordering. This bot will be configured with a confidence threshold of 0.5 for Natural Language Understanding (NLU) intent recognition.

The configuration will include:
1. AWS provider configuration
2. An IAM role for Lex bot execution
3. A Lex bot with basic pizza ordering configuration
4. Required IAM policies and attachments

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_bot_role" {
  name = "lex_pizza_bot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Lex
resource "aws_iam_role_policy" "lex_bot_policy" {
  name = "lex_pizza_bot_policy"
  role = aws_iam_role.lex_bot_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lex:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Lex Bot
resource "aws_lex_bot" "pizza_ordering_bot" {
  name = "PizzaOrderingBot"
  description = "Bot for ordering pizzas"
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding you. Please try again."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you. Could you please rephrase that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  
  nlu_intent_confidence_threshold = 0.5
  
  process_behavior = "BUILD"
  
  voice_id = "Salli"
  
  child_directed = false

  create_version = false

  locale = "en-US"

  depends_on = [aws_iam_role.lex_bot_role]
}

# Output the bot ID
output "lex_bot_id" {
  value = aws_lex_bot.pizza_ordering_bot.id
}
</iac_template>

This Terraform configuration creates an AWS Lex bot for pizza ordering with the following features:
- Sets the NLU intent confidence threshold to 0.5 as requested
- Creates necessary IAM roles and policies for the bot to function
- Configures basic bot settings including abort statements and clarification prompts
- Sets the bot's language to English (US)
- Uses Salli as the voice ID
- Sets a 5-minute idle session timeout
- Includes proper error handling and clarification prompts

Note: This is a basic bot configuration. To make it fully functional for pizza ordering, you would need to add intents, slots, and utterances specific to pizza ordering, which would require additional resources like `aws_lex_intent` and `aws_lex_slot_type`.