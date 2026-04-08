resource "aws_schemas_discoverer" "this" {
  region      = var.region
  source_arn  = var.source_arn
  description = var.description
  tags        = var.tags
}