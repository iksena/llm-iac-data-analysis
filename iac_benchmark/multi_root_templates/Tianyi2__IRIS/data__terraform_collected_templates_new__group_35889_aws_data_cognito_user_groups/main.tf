data "aws_cognito_user_groups" "this" {
  region       = var.region
  user_pool_id = var.user_pool_id
}