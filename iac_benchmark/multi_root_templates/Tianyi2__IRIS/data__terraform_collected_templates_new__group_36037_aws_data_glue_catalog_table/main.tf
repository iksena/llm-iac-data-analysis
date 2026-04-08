data "aws_glue_catalog_table" "this" {
  region           = var.region
  name             = var.name
  database_name    = var.database_name
  catalog_id       = var.catalog_id
  query_as_of_time = var.query_as_of_time
  transaction_id   = var.transaction_id
}