resource "aws_lambda_layer_version_permission" "this" {
  action         = var.action
  layer_name     = var.layer_name
  principal      = var.principal
  statement_id   = var.statement_id
  version_number = var.version_number

  organization_id = var.organization_id
  region          = var.region
  skip_destroy    = var.skip_destroy
}