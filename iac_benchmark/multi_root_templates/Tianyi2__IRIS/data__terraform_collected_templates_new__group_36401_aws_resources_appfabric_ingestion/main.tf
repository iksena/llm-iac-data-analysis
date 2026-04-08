resource "aws_appfabric_ingestion" "this" {
  region         = var.region
  app            = var.app
  app_bundle_arn = var.app_bundle_arn
  ingestion_type = var.ingestion_type
  tenant_id      = var.tenant_id
  tags           = var.tags
}