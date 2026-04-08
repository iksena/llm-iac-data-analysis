provider "aws" {
  alias  = "region"
  region = var.region
}

resource "aws_cognito_user_group" "this" {
  name         = var.name
  user_pool_id = var.user_pool_id
  description  = var.description
  precedence   = var.precedence
  role_arn     = var.role_arn

  provider = aws.region
}