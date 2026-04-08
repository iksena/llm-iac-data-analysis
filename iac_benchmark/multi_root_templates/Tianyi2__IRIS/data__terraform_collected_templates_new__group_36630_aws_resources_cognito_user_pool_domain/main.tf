resource "aws_cognito_user_pool_domain" "this" {
  region                = var.region
  domain                = var.domain
  user_pool_id          = var.user_pool_id
  certificate_arn       = var.certificate_arn
  managed_login_version = var.managed_login_version
}