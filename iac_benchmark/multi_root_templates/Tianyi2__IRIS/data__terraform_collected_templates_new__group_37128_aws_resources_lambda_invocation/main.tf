resource "aws_lambda_invocation" "this" {
  function_name   = var.function_name
  input           = var.input
  lifecycle_scope = var.lifecycle_scope
  qualifier       = var.qualifier
  region          = var.region
  terraform_key   = var.terraform_key
  triggers        = var.triggers
}