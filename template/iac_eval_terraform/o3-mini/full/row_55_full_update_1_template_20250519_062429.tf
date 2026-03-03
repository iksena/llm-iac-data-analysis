Below is a description of the Terraform configuration followed by the complete deployable Terraform HCL program:

Description:
• The provider is configured for AWS in the us-east-1 region.
• An AWS Connect instance is created with SAML-based identity management (required for SAML integration) along with basic inbound and outbound call support.
• An AWS Connect bot association is then created that links the instance with a Lex bot configuration. The Lex bot parameters (name and region) are specified directly in the code.
• No undeclared variables exist and all resources and attributes required for deployment are fully specified.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_connect_instance" "saml_instance" {
  identity_management_type = "SAML"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true
  instance_alias           = "my-saml-connect-instance"
}

resource "aws_connect_bot_association" "bot_assoc" {
  instance_id          = aws_connect_instance.saml_instance.id
  bot_association_name = "my-lex-bot-association"

  lex_bot {
    name       = "my-lex-bot"
    lex_region = "us-east-1"
  }
}
</iac_template>