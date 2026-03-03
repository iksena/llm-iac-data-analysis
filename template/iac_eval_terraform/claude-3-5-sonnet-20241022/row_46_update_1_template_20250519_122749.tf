provider "aws" {
  region = "us-east-1"
}

# Create IAM Role for Lex
resource "aws_iam_role" "lex_role" {
  name = "lex_role"

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

# Create the Lex Bot
resource "aws_lex_bot" "trip_booking_bot" {
  name = "TripBookingBot"
  description = "Bot for booking travel arrangements"
  
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

  child_directed = false

  idle_session_ttl_in_seconds = 300

  locale = "en-US"

  process_behavior = "BUILD"
  
  voice_id = "Salli"

  intent {
    intent_name    = "BookTrip"
    intent_version = "1"
  }

  intent {
    intent_name    = "CancelTrip"
    intent_version = "1"
  }
}

# Create BookTrip Intent
resource "aws_lex_intent" "book_trip" {
  name = "BookTrip"
  description = "Intent to book a trip"
  
  sample_utterances = [
    "I want to book a trip",
    "I need to plan a vacation",
    "Book a holiday",
    "Plan my travel"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }

  slot {
    name        = "Destination"
    description = "The destination city"
    priority    = 1
    slot_type   = "AMAZON.City"
    
    slot_constraint = "Required"
    
    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "Which city would you like to visit?"
        content_type = "PlainText"
      }
    }
  }

  slot {
    name        = "CheckInDate"
    description = "The check-in date"
    priority    = 2
    slot_type   = "AMAZON.DATE"
    
    slot_constraint = "Required"
    
    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "When would you like to check in?"
        content_type = "PlainText"
      }
    }
  }

  slot {
    name        = "Nights"
    description = "Number of nights"
    priority    = 3
    slot_type   = "AMAZON.NUMBER"
    
    slot_constraint = "Required"
    
    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "How many nights would you like to stay?"
        content_type = "PlainText"
      }
    }
  }
}

# Create CancelTrip Intent
resource "aws_lex_intent" "cancel_trip" {
  name = "CancelTrip"
  description = "Intent to cancel a trip"
  
  sample_utterances = [
    "I want to cancel my trip",
    "Cancel my booking",
    "Cancel my travel plans"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}