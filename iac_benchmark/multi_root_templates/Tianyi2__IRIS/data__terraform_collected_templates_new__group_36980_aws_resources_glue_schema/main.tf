resource "aws_glue_schema" "this" {
  region            = var.region
  schema_name       = var.schema_name
  registry_arn      = var.registry_arn
  data_format       = var.data_format
  compatibility     = var.compatibility
  schema_definition = var.schema_definition
  description       = var.description
  tags              = var.tags
}