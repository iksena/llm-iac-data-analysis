I'll help you create an AWS Lex Bot using Terraform. This configuration will create a Lex Bot with basic configuration including a language, IAM role for the bot's execution, and necessary permissions.

The bot will:
1. Create an IAM role for Lex bot execution
2. Create a Lex bot with English (US) as the primary language
3. Set up basic configuration including idle session timeout and child-directed settings
4. Configure COPPA (Children's Online Privacy Protection Act) compliance

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lex
resource "aws_iam_role" "lex_bot_role" {
  name = "lex_bot_role"

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

# Attach basic Lex permissions to the role
resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_bot_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexRunBotsPolicy"
}

# Create the Lex Bot
resource "aws_lex_bot" "demo_bot" {
  name = "DemoBot"
  description = "A demo bot created with Terraform"
  
  data_privacy {
    child_directed = false
  }

  idle_session_ttl_in_seconds = 300

  role_arn = aws_iam_role.lex_bot_role.arn

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

  voice_id = "Salli"

  nlu_intent_confidence_threshold = 0.40

  process_behavior = "BUILD"
}

# Output the bot ID
output "bot_id" {
  value = aws_lex_bot.demo_bot.id
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role that Lex can assume to execute the bot
3. An IAM policy attachment that gives the bot necessary permissions
4. A Lex bot with the following features:
   - Name: DemoBot
   - Child-directed setting: false (COPPA compliance)
   - Session timeout: 300 seconds
   - Abort statement for error handling
   - Clarification prompt with 2 maximum attempts
   - Voice ID set to "Salli"
   - NLU confidence threshold of 0.40
   - Process behavior set to "BUILD"

The configuration includes all necessary components and can be deployed using standard Terraform commands. The bot ID is provided as an output for reference.

Note that this is a basic configuration. To make the bot functional, you would typically need to add intents, slot types, and other conversational elements, which can be added using additional Terraform resources as needed.