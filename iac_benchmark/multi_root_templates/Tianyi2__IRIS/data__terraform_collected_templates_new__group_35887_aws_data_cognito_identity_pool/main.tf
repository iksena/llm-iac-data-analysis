data "aws_cognito_identity_pool" "this" {
  region             = var.region
  identity_pool_name = var.identity_pool_name
}