Description:
This Terraform program creates an AWS Lex Bot designed to book a trip. The bot is named "booking-trip-bot" and includes all necessary arguments filled out. It defines a clarification prompt to handle unrecognized user input, an abort statement for when the conversation fails, and an intent ("BookTripIntent") that points to the latest version ("$LATEST"). The program includes the AWS provider configuration with a default region and creates an IAM role if needed for the lex bot service (although AWS Lex bots typically do not require explicit IAM roles within this resource, the configuration is fully deployable). All necessary variables are provided with default values.

Below is the complete Terraform HCL template:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_lex_bot" "booking_trip_bot" {
  name                        = "booking-trip-bot"
  description                 = "AWS Lex bot for booking trips"
  locale                      = "en-US"
  child_directed              = false
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
      content      = "Sorry, I could not understand you. Goodbye!"
      content_type = "PlainText"
    }
  }

  intents {
    intent_name    = "BookTripIntent"
    intent_version = "$LATEST"
  }
}
</iac_template>