To create an `aws_connect_bot_association` resource, we need to set up an Amazon Connect instance and an Amazon Lex bot. The `aws_connect_bot_association` resource will associate the Lex bot with the Connect instance. We will also need to define IAM roles and policies to allow the Connect instance to interact with the Lex bot. The configuration will include the necessary provider setup, IAM roles, and the association resource.

Here is the Terraform HCL configuration:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "connect_instance_role" {
  name = "ConnectInstanceRole"

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
  name = "ConnectInstancePolicy"
  role = aws_iam_role.connect_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lex:PostText",
          "lex:PostContent",
          "lex:RecognizeText",
          "lex:RecognizeUtterance"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_connect_instance" "example" {
  identity_management_type = "CONNECT_MANAGED"
  instance_alias           = "example-connect-instance"
}

resource "aws_lex_bot" "example" {
  name        = "ExampleLexBot"
  description = "An example Lex bot"
  locale      = "en-US"
  child_directed = false

  intents {
    intent_name = "HelloWorldIntent"
    sample_utterances = ["Hello", "Hi", "Hey"]
    fulfillment_activity {
      type = "ReturnIntent"
    }
  }
}

resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  lex_bot {
    name   = aws_lex_bot.example.name
    region = "us-east-1"
  }
}
```

</iac_template>

This configuration sets up an Amazon Connect instance and an Amazon Lex bot, then associates the Lex bot with the Connect instance using the `aws_connect_bot_association` resource. The IAM role and policy are configured to allow the Connect instance to interact with the Lex bot.