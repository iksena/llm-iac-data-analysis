resource "aws_lambda_function_recursion_config" "this" {
  function_name  = var.function_name
  recursive_loop = var.recursive_loop
  region         = var.region
}