resource "aws_lambda_provisioned_concurrency_config" "this" {
  function_name                     = var.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier                         = var.qualifier
  region                            = var.region
  skip_destroy                      = var.skip_destroy

  timeouts {
    create = "15m"
    update = "15m"
  }
}