resource "aws_iam_security_token_service_preferences" "this" {
  global_endpoint_token_version = var.global_endpoint_token_version
}