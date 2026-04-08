data "aws_apigatewayv2_export" "this" {
  region             = var.region
  api_id             = var.api_id
  specification      = var.specification
  output_type        = var.output_type
  export_version     = var.export_version
  include_extensions = var.include_extensions
  stage_name         = var.stage_name
}