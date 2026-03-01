provider "aws" {
  region = "us-east-1"
}

###########################################################
# Create an AWS Connect instance named kids_instance.
###########################################################
resource "aws_connect_instance" "kids_instance" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true

  # Optionally, you can set an alias.
  instance_alias = "kids-connect-instance"
}

###########################################################
# Create a minimal AWS Lex bot for kids.
# This Lex bot is configured with a dummy intent and simple
# clarification and abort statements so that it can be used
# for the bot association.
###########################################################
resource "aws_lex_bot" "kids_bot" {
  name                      = "kids-bot"
  description               = "A Lex bot for kids support."
  locale                    = "en-US"
  voice_id                  = "Joanna"
  process_behavior          = "BUILD"
  child_directed            = false
  idle_session_ttl_in_seconds = 300

  clarification_prompt {
    max_attempts = 2
    message {
      content      = "I didn't understand that. Can you please repeat?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "Sorry, I could not understand. Goodbye!"
      content_type = "PlainText"
    }
  }

  intents {
    intent_name    = "KidsIntent"
    intent_version = "$LATEST"
  }
}

###########################################################
# Associate the Lex bot with the Connect instance.
# This aws_connect_bot_association resource creates the association
# between our Connect instance and the Lex bot for kids.
###########################################################
resource "aws_connect_bot_association" "kids_bot_association" {
  instance_id = aws_connect_instance.kids_instance.id
  bot_id      = aws_lex_bot.kids_bot.id
  bot_type    = "LEX"
}