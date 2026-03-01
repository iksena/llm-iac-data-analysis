Below is the complete Terraform configuration. It defines an AWS provider, creates an IAM role with a trust policy for Lex, and then creates an AWS Lex V2 bot named “children” with a data privacy setting indicating it is child directed. You can deploy this configuration directly.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lex_v2_bot_role" {
  name = "lex_v2_bot_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_lex_v2_bot" "children" {
  name                          = "children"
  description                   = "Amazon Lex V2 bot for children"
  role_arn                      = aws_iam_role.lex_v2_bot_role.arn
  idle_session_ttl_in_seconds   = 300

  data_privacy {
    child_directed = true
  }
}
</iac_template>