I'll help you create an AWS Lex bot with multiple slots using Terraform. This configuration will create a Lex bot that simulates a hotel booking assistant with slots for check-in date, number of nights, and room type.

Description:
- Creates an AWS Lex V1 bot for hotel bookings
- Includes an intent for booking a hotel room
- Defines multiple slots (check-in date, number of nights, room type)
- Sets up appropriate IAM role for Lex
- Configures slot validation and prompts
- Includes error handling and confirmation prompts

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# IAM Role for Lex
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

  idle_session_ttl_in_seconds = 600
  process_behavior            = "BUILD"
  voice_id                   = "Salli"
}

# Intent
resource "aws_lex_intent" "book_hotel" {
  name = "BookHotel"
  description = "Intent to book a hotel room"
  create_version = true
  parent_intent_signature = "AMAZON.SearchHotel"

  conclusion_statement {
    message {
      content = "Thank you! Your hotel room has been booked."
      content_type = "PlainText"
    }
  }

  confirmation_prompt {
    max_attempts = 2
    message {
      content = "Would you like to proceed with booking a {RoomType} room for {Nights} nights starting {CheckInDate}?"
      content_type = "PlainText"
    }
  }

  rejection_statement {
    message {
      content = "Booking cancelled. Is there anything else I can help you with?"
      content_type = "PlainText"
    }
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
    slot_type   = "AMAZON.Room"
    slot_constraint = "Required"
    value_elicitation_prompt {
      max_attempts = 2
      message {
        content      = "What type of room would you like (standard, deluxe, or suite)?"
        content_type = "PlainText"
      }
    }
  }

  depends_on = [aws_lex_bot.hotel_booking_bot]
}

# Bot-Intent Association
resource "aws_lex_bot_alias" "hotel_booking_bot_alias" {
  bot_name    = aws_lex_bot.hotel_booking_bot.name
  description = "Production version of the hotel booking bot"
  name        = "BookingBotProduction"

  conversation_logs {
    iam_role_arn = aws_iam_role.lex_role.arn
    log_settings {
      destination = "CLOUDWATCH_LOGS"
      log_type    = "TEXT"
    }
  }
}
</iac_template>

This Terraform configuration creates:
1. An IAM role for Lex bot operations
2. A Lex bot named "HotelBookingBot"
3. An intent named "BookHotel" with three slots:
   - CheckInDate (using AMAZON.DATE slot type)
   - Nights (using AMAZON.NUMBER slot type)
   - RoomType (using AMAZON.Room slot type)
4. A bot alias for production deployment

Each slot has its own validation prompt and the intent includes confirmation and rejection statements. The bot will guide users through the booking process by collecting all required information through the defined slots.

To deploy this configuration:
1. Ensure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Note: AWS Lex V1 is used in this example as it has better Terraform support. For production use, consider using Lex V2, although it might require more complex configuration.