resource "aws_codebuild_source_credential" "this" {
  region      = var.region
  auth_type   = var.auth_type
  server_type = var.server_type
  token       = var.token
  user_name   = var.user_name
}