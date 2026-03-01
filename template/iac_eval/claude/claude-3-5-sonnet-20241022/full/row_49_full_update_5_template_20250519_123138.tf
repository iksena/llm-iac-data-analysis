I'll create a template using the correct resource type `aws_lex_bot`. Here's the corrected version:

<iac_template>
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
  
  nlu_intent_confidence_threshold = 0.5
  
  child_directed = false
  
  idle_session_ttl_in_seconds = 300
  
  process_behavior = "BUILD"
  
  voice_id = "Salli"
  
  abort_statement {
    message {
      content      = "Sorry, I cannot help you at this time. Please try again later."
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
}

# Output the bot ID
output "lex_bot_id" {
  value = aws_lex_bot.pizza_ordering_bot.id
}
</iac_template>