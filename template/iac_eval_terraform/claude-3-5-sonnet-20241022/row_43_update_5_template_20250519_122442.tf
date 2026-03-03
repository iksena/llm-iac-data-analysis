provider "aws" {
  region = "us-east-1"
}

# IAM Role for Lex
resource "aws_iam_role" "lex_role" {
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

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexFullAccess"
}

# Intent
resource "aws_lex_intent" "book_hotel" {
  name = "BookHotel"
  description = "Intent to book a hotel room"
  
  fulfillment_activity {
    type = "ReturnIntent"
  }

  sample_utterances = [
    "I want to book a hotel",
    "Book a room",
    "Make a hotel reservation"
  ]

  slot {
    name        = "CheckInDate"
    description = "The check-in date for the hotel"
    priority    = 1
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
    description = "Number of nights for the stay"
    priority    = 2
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

  slot {
    name        = "RoomType"
    description = "Type of room desired"
    priority    = 3
    slot_type   = "AMAZON.AlphaNumeric"
    slot_constraint = "Required"
    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "What type of room would you like (standard, deluxe, or suite)?"
        content_type = "PlainText"
      }
    }
  }

  conclusion_statement {
    message {
      content = "Thank you! Your hotel room has been booked."
      content_type = "PlainText"
    }
  }
}

# Lex Bot
resource "aws_lex_bot" "hotel_booking_bot" {
  name = "HotelBookingBot"
  description = "Bot for hotel bookings"
  child_directed = false
  
  abort_statement {
    message {
      content      = "Sorry, I'm having trouble understanding. Please try again later."
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
  process_behavior            = "BUILD"
  voice_id                   = "Salli"

  intent {
    intent_name    = aws_lex_intent.book_hotel.name
    intent_version = "$LATEST"
  }
}

# Bot-Intent Association
resource "aws_lex_bot_alias" "hotel_booking_bot_alias" {
  bot_name    = aws_lex_bot.hotel_booking_bot.name
  description = "Production version of the hotel booking bot"
  name        = "BookingBotProduction"
}