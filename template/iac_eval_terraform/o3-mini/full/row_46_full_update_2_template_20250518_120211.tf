Below is an improved, deployable Terraform configuration that defines an AWS Lex bot for booking trips. In this version the block names have been adjusted (for example, using an "intent" block rather than "intents") and syntax errors have been corrected so that Terraform can parse the file successfully.

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

  intent {
    intent_name    = "BookTripIntent"
    intent_version = "$LATEST"
  }
}
</iac_template>