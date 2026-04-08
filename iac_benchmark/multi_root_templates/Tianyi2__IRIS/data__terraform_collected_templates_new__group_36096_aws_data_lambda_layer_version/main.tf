locals {
  # Validation: ensure version conflicts with compatible_runtime and compatible_architecture
  validation_check = (
    (var.layer_version == null) ||
    (var.compatible_runtime == null && var.compatible_architecture == null)
  ) ? null : error("data_aws_lambda_layer_version: layer_version conflicts with compatible_runtime and compatible_architecture. Only one can be specified.")
}

data "aws_lambda_layer_version" "this" {
  layer_name              = var.layer_name
  compatible_architecture = var.compatible_architecture
  compatible_runtime      = var.compatible_runtime
  region                  = var.region
  version                 = var.layer_version
}