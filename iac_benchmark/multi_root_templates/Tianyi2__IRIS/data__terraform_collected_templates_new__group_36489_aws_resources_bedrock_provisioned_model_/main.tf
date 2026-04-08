resource "aws_bedrock_provisioned_model_throughput" "this" {
  region                 = var.region
  commitment_duration    = var.commitment_duration
  model_arn              = var.model_arn
  model_units            = var.model_units
  provisioned_model_name = var.provisioned_model_name
  tags                   = var.tags

  timeouts {
    create = var.create_timeout
  }
}