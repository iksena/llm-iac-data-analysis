To create an AWS Lex Bot using Terraform, we will define a configuration that sets up an AWS Lex Bot with a basic intent. The bot will be configured with a sample intent that can be expanded upon for more complex interactions. We will also set up the necessary IAM roles and policies to allow the Lex Bot to function properly. The configuration will include a provider setup for AWS in a specified region.

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

resource "aws_iam_role_policy" "lex_bot_policy" {
  name   = "LexBotPolicy"
  role   = aws_iam_role.lex_bot_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "polly:SynthesizeSpeech",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lex_bot" "example_bot" {
  name        = "ExampleBot"
  description = "A simple example Lex bot"
  role_arn    = aws_iam_role.lex_bot_role.arn
  locale      = "en-US"
  child_directed = false

  intent {
    intent_name    = "HelloWorldIntent"
    intent_version = "$LATEST"
  }
}

resource "aws_lex_intent" "hello_world_intent" {
  name        = "HelloWorldIntent"
  description = "An intent to say hello"
  sample_utterances = [
    "Hello",
    "Hi",
    "Hey"
  ]

  fulfillment_activity {
    type = "ReturnIntent"
  }
}
```
</iac_template>

This Terraform configuration sets up an AWS Lex Bot named "ExampleBot" with a simple intent called "HelloWorldIntent". The bot is configured to use the "en-US" locale and is not child-directed. The IAM role and policy are created to allow the bot to interact with AWS services like Polly for speech synthesis and CloudWatch for logging. The intent is configured with sample utterances and a fulfillment activity that simply returns the intent.