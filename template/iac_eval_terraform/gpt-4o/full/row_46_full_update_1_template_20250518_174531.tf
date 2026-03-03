To create an AWS Lex Bot for booking a trip, we will define a Terraform configuration that sets up an AWS Lex Bot with intents, slots, and sample utterances. The bot will be configured to handle a simple trip booking scenario, where users can specify details such as destination, date, and number of travelers. We will also configure the necessary IAM roles and policies to allow the Lex Bot to function correctly.

The configuration will include:
- An AWS Lex Bot with a specific name and description.
- An intent for booking a trip, including slots for destination, date, and number of travelers.
- Sample utterances to trigger the intent.
- An IAM role with permissions for the Lex Bot to interact with AWS services.

The configuration will be deployed in the `us-east-1` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "LexBotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lex_bot_policy" {
  name        = "LexBotPolicy"
  description = "Policy for Lex Bot to access necessary services"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:*",
          "logs:*",
          "s3:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lex_bot_policy_attachment" {
  role       = aws_iam_role.lex_bot_role.name
  policy_arn = aws_iam_policy.lex_bot_policy.arn
}

resource "aws_lex_bot" "trip_booking_bot" {
  name        = "TripBookingBot"
  description = "A bot to help users book trips"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name = "BookTrip"
    sample_utterances = [
      "I want to book a trip",
      "Book a trip for me",
      "Help me plan a trip"
    ]

    slot {
      name        = "Destination"
      slot_type   = "AMAZON.City"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages = [
          {
            content_type = "PlainText"
            content      = "Where would you like to travel?"
          }
        ]
        max_attempts = 3
      }
    }

    slot {
      name        = "TravelDate"
      slot_type   = "AMAZON.DATE"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages = [
          {
            content_type = "PlainText"
            content      = "When do you want to travel?"
          }
        ]
        max_attempts = 3
      }
    }

    slot {
      name        = "NumberOfTravelers"
      slot_type   = "AMAZON.NUMBER"
      slot_constraint = "Required"
      value_elicitation_prompt {
        messages = [
          {
            content_type = "PlainText"
            content      = "How many people are traveling?"
          }
        ]
        max_attempts = 3
      }
    }
  }
}
```
</iac_template>