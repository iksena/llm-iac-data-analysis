data "aws_lakeformation_data_lake_settings" "this" {
  region     = var.region
  catalog_id = var.catalog_id
}