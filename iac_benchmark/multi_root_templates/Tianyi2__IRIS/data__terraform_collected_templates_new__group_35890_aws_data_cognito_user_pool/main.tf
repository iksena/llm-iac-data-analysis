data "aws_cognito_user_pool" "this" {
  region       = var.region
  user_pool_id = var.user_pool_id
}