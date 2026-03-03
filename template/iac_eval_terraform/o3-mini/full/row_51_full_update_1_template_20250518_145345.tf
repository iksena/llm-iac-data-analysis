Below is a description of the Terraform program followed by the complete HCL configuration.

Description:
This Terraform configuration deploys a minimal Amazon Lex V2 Bot. It sets up an IAM role (and attaches a simple policy to allow logging to CloudWatch) that Amazon Lex assumes when running the bot. The aws_lexv2_bot resource is defined with required attributes including a name, description, the IAM role ARN, and data privacy settings. The AWS provider is configured with a default region.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_bot_role" {
  name = "lex-v2-bot-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "",
        Effect    = "Allow",
        Principal = {
          Service = "lex.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lex_bot_policy" {
  name = "lex-v2-bot-policy"
  role = aws_iam_role.lex_bot_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lexv2_bot" "lex_bot" {
  name                        = "my-lex-v2-bot"
  description                 = "Lex V2 Bot created via Terraform"
  role_arn                    = aws_iam_role.lex_bot_role.arn
  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = false
  }
}
</iac_template>