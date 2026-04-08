resource "aws_dataexchange_data_set" "this" {
  region      = var.region
  asset_type  = var.asset_type
  description = var.description
  name        = var.name
  tags        = var.tags
}