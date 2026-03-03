Below is a description of the Terraform program followed by the complete deployable Terraform HCL configuration:

Description:
This Terraform configuration sets up an AWS Lex Bot using the aws_lex_bot resource. The Lex Bot is defined with a name ("example-lex-bot"), description, locale ("en-US"), and configuration settings such as whether it is child-directed, session timeout, and the build process behavior. Two prompt blocks are also defined: one for clarifying user input (clarification_prompt) and one for abort statements (abort_statement). The configuration includes the AWS provider with a default region (us-east-1) defined by a variable. No IAM roles are required for this simple Lex Bot setup since it does not integrate with AWS Lambda or other services that require an assumed role.

Below is the complete Terraform configuration:

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
    messages = [
      {
        content      = "I didn't understand that. Can you please try again?"
        content_type = "PlainText"
      }
    ]
  }

  abort_statement {
    messages = [
      {
        content      = "I am sorry, I cannot help with that at the moment."
        content_type = "PlainText"
      }
    ]
  }
}
</iac_template>