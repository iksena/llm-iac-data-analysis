I'll help you create a Terraform configuration to set up an Amazon Connect Bot Association. This configuration will associate a Lex bot with an Amazon Connect instance. The setup includes creating an Amazon Connect instance, a Lex bot, necessary IAM roles, and the bot association.

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create IAM role for Amazon Connect
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

# Attach necessary policies to the Connect role
resource "aws_iam_role_policy_attachment" "connect_policy" {
  role       = aws_iam_role.connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonConnectServiceRole"
}

# Create Amazon Connect Instance
resource "aws_connect_instance" "example" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled   = true
  instance_alias         = "example-connect-instance"
  outbound_calls_enabled = true
}

# Create IAM role for Lex
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

# Create Lex Bot
resource "aws_lexv2_bot" "example" {
  name = "example_bot"
  description = "Example Lex bot for Connect"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  bot_locale {
    locale_id = "en_US"
    nlu_intent_confidence_threshold = 0.40
  }
}

# Create Lex Bot Version
resource "aws_lexv2_bot_version" "example" {
  bot_id = aws_lexv2_bot.example.id
  description = "Version 1"
}

# Create Lex Bot Alias
resource "aws_lexv2_bot_alias" "example" {
  bot_alias_name = "example_alias"
  bot_id         = aws_lexv2_bot.example.id
  bot_version    = aws_lexv2_bot_version.example.bot_version
  description    = "Example bot alias"
}

# Create Connect Bot Association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  lex_bot {
    lex_region = "us-west-2"
    name       = aws_lexv2_bot.example.name
  }
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-west-2 region
2. Creates an IAM role for Amazon Connect with necessary permissions
3. Creates an Amazon Connect instance
4. Creates an IAM role for Amazon Lex
5. Creates a Lex V2 bot with basic configuration
6. Creates a version for the Lex bot
7. Creates an alias for the Lex bot
8. Finally, creates the Connect Bot Association between the Connect instance and the Lex bot

The configuration includes all necessary components and dependencies to create a working Connect Bot Association. All resources are properly declared and configured with the minimum required parameters. The configuration uses the us-west-2 region, but you can modify this to match your needs.

Note that this is a basic configuration and you might want to add additional settings based on your specific requirements, such as:
- Additional bot configurations
- More specific IAM permissions
- Custom bot locale settings
- Additional Connect instance configurations

Remember that you'll need appropriate AWS permissions to create these resources, and you'll be billed for the AWS resources created by this configuration.