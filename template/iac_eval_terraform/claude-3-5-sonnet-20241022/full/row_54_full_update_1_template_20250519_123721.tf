I'll help you create a Terraform configuration to set up an Amazon Connect Bot Association, which will integrate a chatbot with Amazon Connect instance. This configuration will be designed for a kids-oriented bot association. We'll need to create an Amazon Connect instance, a Lex bot, and then associate them together.

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create an IAM role for Amazon Connect
resource "aws_iam_role" "connect_role" {
  name = "connect_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "connect_policy" {
  role       = aws_iam_role.connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonConnectServiceRole"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "kids_connect" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias         = "kids-connect-instance"
  outbound_calls_enabled = true
}

# Create Lex Bot
resource "aws_lex_bot" "kids_bot" {
  name = "KidsHelperBot"
  description = "A bot designed to help kids"
  
  abort_statement {
    message {
      content      = "Sorry, I couldn't understand. Could you try again?"
      content_type = "PlainText"
    }
  }

  child_directed = true
  
  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand you. Can you please repeat that?"
      content_type = "PlainText"
    }
  }

  idle_session_ttl_in_seconds = 300
  
  intent {
    intent_name    = "HelloIntent"
    intent_version = "1"
  }

  process_behavior = "BUILD"
  voice_id        = "Ivy"
}

# Create Lex Bot Version
resource "aws_lex_bot_version" "kids_bot_version" {
  name    = aws_lex_bot.kids_bot.name
  version = "1"
}

# Create Lex Bot Alias
resource "aws_lex_bot_alias" "kids_bot_alias" {
  bot_name    = aws_lex_bot.kids_bot.name
  bot_version = aws_lex_bot_version.kids_bot_version.version
  description = "Production bot alias"
  name        = "KidsHelperBotAlias"
}

# Create the Connect Bot Association
resource "aws_connect_bot_association" "kids_bot_association" {
  instance_id = aws_connect_instance.kids_connect.id
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lex_bot.kids_bot.name
  }
}

# Variables with default values
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
</iac_template>

This Terraform configuration creates:
1. An IAM role for Amazon Connect with necessary permissions
2. An Amazon Connect instance
3. A Lex bot specifically designed for kids (with child_directed flag set to true)
4. A Lex bot version
5. A Lex bot alias
6. A Connect Bot Association linking the Connect instance with the Lex bot

The configuration includes:
- Proper IAM roles and permissions
- A basic Lex bot configuration with a simple intent
- Child-directed flag set to true (required for kids-oriented bots)
- All necessary resources properly linked together
- Default variable values
- Provider configuration for AWS

Note that this is a basic configuration and you might want to add more intents, utterances, and slot types to the Lex bot depending on your specific use case. The bot is configured with minimal settings to demonstrate the association between Amazon Connect and Lex.