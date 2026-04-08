data "aws_cognito_user_group" "this" {
  region       = var.region
  name         = var.name
  user_pool_id = var.user_pool_id
}