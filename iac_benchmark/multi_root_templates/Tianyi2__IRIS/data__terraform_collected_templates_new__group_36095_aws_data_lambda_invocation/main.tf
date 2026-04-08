data "aws_lambda_invocation" "this" {
  function_name = var.function_name
  input         = var.input
  qualifier     = var.qualifier
  region        = var.region
}