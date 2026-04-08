resource "aws_appintegrations_data_integration" "this" {
  region      = var.region
  description = var.description
  kms_key     = var.kms_key
  name        = var.name
  source_uri  = var.source_uri
  tags        = var.tags

  schedule_config {
    first_execution_from = var.schedule_config.first_execution_from
    object               = var.schedule_config.object
    schedule_expression  = var.schedule_config.schedule_expression
  }
}