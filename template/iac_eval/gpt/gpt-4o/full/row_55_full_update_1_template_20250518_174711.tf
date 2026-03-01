To fulfill the business need, we will create an AWS Connect Bot Association using Terraform. This involves setting up an AWS Connect instance with SAML authentication and associating a bot with it. We will define the necessary IAM roles and policies to allow the Connect instance to interact with the bot. The configuration will include the AWS provider setup, the Connect instance, and the bot association.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connect_instance_role" {
  name = "connect-instance-role"

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

resource "aws_iam_role_policy" "connect_instance_policy" {
  name   = "connect-instance-policy"
  role   = aws_iam_role.connect_instance_role.id
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

resource "aws_connect_instance" "example" {
  identity_management_type = "SAML"
  instance_alias           = "example-connect-instance"

  directory_id = "d-xxxxxxxxxx" # Replace with your directory ID
}

resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  lex_bot {
    name     = "example-bot"
    region   = "us-east-1"
  }
}
```
</iac_template>

This configuration sets up an AWS Connect instance with SAML authentication and associates a Lex bot with it. The IAM role and policy allow the Connect instance to interact with the bot. Make sure to replace the `directory_id` with your actual directory ID for SAML integration.