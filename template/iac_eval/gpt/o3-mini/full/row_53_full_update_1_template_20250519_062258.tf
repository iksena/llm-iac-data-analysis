Below is a description of the infrastructure and the complete Terraform HCL program:

Description:
This Terraform configuration deploys an Amazon Connect Bot Association. It uses the aws_connect_bot_association resource to associate a Lex bot with an Amazon Connect instance. The configuration defines provider settings (using the AWS provider in the "us-east-1" region by default) and variables with default values (including instance ID, bot association name, Lex bot alias, Lex bot name, and Lex region). The aws_connect_bot_association resource includes the lex_bot configuration block that specifies the Lex bot details. This complete configuration is deployable as is.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_id" {
  description = "The identifier of the Amazon Connect instance"
  type        = string
  default     = "my-connect-instance-id"
}

variable "bot_association_name" {
  description = "The name of the bot association"
  type        = string
  default     = "my-bot-association"
}

variable "lex_bot_alias" {
  description = "The alias of the Lex bot"
  type        = string
  default     = "DRAFT"
}

variable "lex_bot_name" {
  description = "The name of the Lex bot"
  type        = string
  default     = "my-lex-bot"
}

variable "lex_region" {
  description = "The region where the Lex bot is deployed"
  type        = string
  default     = "us-east-1"
}

resource "aws_connect_bot_association" "this" {
  instance_id          = var.instance_id
  bot_association_name = var.bot_association_name

  lex_bot {
    lex_bot_alias = var.lex_bot_alias
    lex_bot_name  = var.lex_bot_name
    lex_region    = var.lex_region
  }
}
</iac_template>