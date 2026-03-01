To create an AWS Connect Bot Association using Terraform, we need to define a configuration that sets up an Amazon Connect instance and associates a Lex bot with it. This configuration will include the necessary IAM roles and policies to allow the Connect instance to interact with the Lex bot. We will also specify the region and other required parameters.

Below is the Terraform configuration to achieve this:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connect_service_role" {
  name = "ConnectServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "connect_service_policy" {
  name   = "ConnectServicePolicy"
  role   = aws_iam_role.connect_service_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "lex:PostText",
          "lex:PostContent"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_connect_instance" "connect_instance" {
  identity_management_type = "CONNECT_MANAGED"
  instance_alias           = "KidsConnectInstance"
}

resource "aws_lex_bot" "kids_lex_bot" {
  name        = "KidsLexBot"
  description = "A Lex bot for kids"
  locale      = "en-US"
  child_directed = true

  # Define intents and other bot configurations here
}

resource "aws_connect_bot_association" "bot_association" {
  instance_id = aws_connect_instance.connect_instance.id
  lex_bot {
    name     = aws_lex_bot.kids_lex_bot.name
    lex_region = "us-east-1"
  }
}
```

</iac_template>

This configuration sets up an Amazon Connect instance and associates it with a Lex bot specifically designed for kids. The IAM role and policy allow the Connect instance to interact with the Lex bot. The Lex bot is configured to be child-directed, which is important for compliance with regulations regarding children's data.