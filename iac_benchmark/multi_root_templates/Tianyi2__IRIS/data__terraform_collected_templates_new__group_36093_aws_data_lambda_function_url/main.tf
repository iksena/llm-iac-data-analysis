data "aws_lambda_function_url" "this" {
  function_name = var.function_name
  qualifier     = var.qualifier
  region        = var.region
}