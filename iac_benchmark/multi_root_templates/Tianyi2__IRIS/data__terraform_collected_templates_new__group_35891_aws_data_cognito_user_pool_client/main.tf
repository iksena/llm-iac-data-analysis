data "aws_cognito_user_pool_client" "this" {
  client_id    = var.client_id
  user_pool_id = var.user_pool_id
}