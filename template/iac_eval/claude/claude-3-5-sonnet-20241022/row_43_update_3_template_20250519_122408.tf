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
          Service = "lexv2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "lex_policy" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLexV2BotPolicy"
}

# Lex Bot
resource "aws_lexv2_bot" "hotel_booking_bot" {
  name = "HotelBookingBot"
  description = "Bot for hotel bookings"
  idle_session_ttl_in_seconds = 300
  role_arn = aws_iam_role.lex_role.arn

  data_privacy {
    child_directed = false
  }

  type = "BOT"
}

# Bot Locale
resource "aws_lexv2_bot_locale" "bot_locale" {
  bot_id      = aws_lexv2_bot.hotel_booking_bot.id
  bot_version = "DRAFT"
  locale_id   = "en_US"
  description = "English (US) locale for Hotel Booking Bot"

  nlu_intent_confidence_threshold = 0.40
}

# Bot Alias
resource "aws_lexv2_bot_alias" "test_alias" {
  bot_alias_name = "TestAlias"
  bot_id         = aws_lexv2_bot.hotel_booking_bot.id
  bot_version    = "DRAFT"

  sentiment_analysis_settings {
    detect_sentiment = false
  }
}

# Intent
resource "aws_lexv2_bot_intent" "book_hotel" {
  bot_id      = aws_lexv2_bot.hotel_booking_bot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2_bot_locale.bot_locale.locale_id
  
  intent_name = "BookHotel"
  description = "Intent to book a hotel room"

  sample_utterances {
    utterance = "I want to book a hotel"
  }

  sample_utterances {
    utterance = "Book a room"
  }

  sample_utterances {
    utterance = "Make a hotel reservation"
  }

  fulfillment_code_hook {
    enabled = false
  }
}