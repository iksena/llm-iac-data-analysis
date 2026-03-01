To create an AWS Lex V2 bot using Terraform, we need to define a configuration that sets up the Lex V2 bot with its intents, slots, and any necessary IAM roles for permissions. The bot will be created in a specified AWS region, and we will ensure that all necessary resources are declared and configured properly. The configuration will include the AWS provider setup, IAM roles for Lex V2, and the Lex V2 bot resource itself.

Here is the Terraform HCL configuration for creating an AWS Lex V2 bot:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_v2_bot_role" {
  name = "LexV2BotRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lexv2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_v2_bot_policy" {
  name   = "LexV2BotPolicy"
  role   = aws_iam_role.lex_v2_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "polly:SynthesizeSpeech",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lexv2_bot" "example_bot" {
  name        = "ExampleBot"
  role_arn    = aws_iam_role.lex_v2_bot_role.arn
  data_privacy {
    child_directed = false
  }
  idle_session_ttl_in_seconds = 300
  locale {
    locale_id = "en_US"
    nlu_intent_confidence_threshold = 0.40
    voice_settings {
      voice_id = "Joanna"
    }
  }
}
```
</iac_template>

This configuration sets up an AWS Lex V2 bot named "ExampleBot" in the "us-east-1" region. It includes an IAM role with the necessary permissions for the bot to function, such as accessing Polly for speech synthesis and CloudWatch for logging. The bot is configured with a locale for English (US) and a voice setting using the "Joanna" voice. The data privacy setting indicates that the bot is not directed at children, and the idle session timeout is set to 300 seconds.