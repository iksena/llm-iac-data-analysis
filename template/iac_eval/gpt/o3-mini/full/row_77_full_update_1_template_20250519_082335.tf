Below is a description of the Terraform program that meets your requirement:

Description:
• The configuration sets up the AWS provider in the us-east-1 region.
• An IAM role is created for Amazon Kendra with an assume role policy that permits the service "kendra.amazonaws.com" to assume the role.
• A basic Amazon Kendra index is defined using the resource aws_kendra_index. The index is given a default name and description, and is set to the DEVELOPER edition.
• The index resource also includes a user group resolution configuration block with its mode set to "AWS_SSO" (to enable user group resolution).
• All variables used include default values ensuring that the configuration is fully deployable.

Below is the complete Terraform HCL program:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "kendra_index_name" {
  description = "The name of the Kendra index"
  type        = string
  default     = "example-kendra-index"
}

resource "aws_iam_role" "kendra_index_role" {
  name = "kendra-index-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_kendra_index" "this" {
  name    = var.kendra_index_name
  edition = "DEVELOPER"

  description = "Example Kendra index with user group resolution configuration"

  role_arn = aws_iam_role.kendra_index_role.arn

  user_group_resolution_configuration {
    user_group_resolution_mode = "AWS_SSO"
  }
}
</iac_template>