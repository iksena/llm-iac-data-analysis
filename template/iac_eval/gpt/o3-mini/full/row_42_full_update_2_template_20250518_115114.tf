Below is an improved version of the Terraform configuration. In this version, the clarification_prompt and abort_statement blocks have been adjusted so that nested message blocks are used (instead of a list), which is the proper Terraform syntax for the aws_lex_bot resource.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources into"
  default     = "us-east-1"
}

resource "aws_lex_bot" "example" {
  name                        = "example-lex-bot"
  description                 = "An example Lex Bot created by Terraform."
  locale                      = "en-US"
  child_directed              = false
  idle_session_ttl_in_seconds = 300
  process_behavior            = "BUILD"

  clarification_prompt {
    max_attempts = 2

    message {
      content      = "I didn't understand that. Can you please try again?"
      content_type = "PlainText"
    }
  }

  abort_statement {
    message {
      content      = "I am sorry, I cannot help with that at the moment."
      content_type = "PlainText"
    }
  }
}
</iac_template>