data "aws_glue_data_catalog_encryption_settings" "this" {
  region     = var.region
  catalog_id = var.catalog_id
}