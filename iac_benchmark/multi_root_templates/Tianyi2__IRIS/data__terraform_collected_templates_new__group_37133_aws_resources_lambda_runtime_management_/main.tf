resource "aws_lambda_runtime_management_config" "this" {
  function_name       = var.function_name
  qualifier           = var.qualifier
  region              = var.region
  runtime_version_arn = var.runtime_version_arn
  update_runtime_on   = var.update_runtime_on
}